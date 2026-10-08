import 'dart:async';

import 'hooks/progress_hook.dart';
import 'models.dart';
import 'progress_rules.dart';
import 'repositories.dart';
import 'template_validation.dart';
import 'widget_events.dart';

/// Outcome of a progress operation, for UI feedback.
class ProgressResult {
  const ProgressResult({this.task, this.event, this.dayCompleted = false});

  static const none = ProgressResult();

  final DailyTask? task;
  final TaskEvent? event;

  /// `true` if this change completed the whole day for the first time.
  final bool dayCompleted;

  bool get changed => event != null;
  bool get taskCompleted => event?.kind == EventKind.complete;
}

/// Sample data written on first launch (localized by the caller).
class SeedContent {
  const SeedContent({required this.templates, required this.profile});

  final List<TaskTemplate> templates;
  final Profile profile;
}

/// The only entry point for state changes. Every change is persisted
/// together with its [TaskEvent] in one transaction, after which all
/// [ProgressHook]s are notified.
class TaskService {
  TaskService({
    required this._tasks,
    required this._settings,
    this._hooks = const [],
    this._clock = DateTime.now,
    this._onHookError,
  });

  /// How far back missing days are generated when the app wasn't opened.
  static const int maxBackfillDays = 62;

  final TaskRepository _tasks;
  final SettingsRepository _settings;
  final List<ProgressHook> _hooks;
  final Clock _clock;
  final void Function(Object, StackTrace)? _onHookError;

  DateTime now() => _clock();

  Future<int> _dayStartHour() async =>
      (await _settings.loadSettings()).dayStartHour;

  /// The logical date right now (respects `dayStartHour`).
  Future<LocalDate> today() async =>
      DayClock.logicalDate(_clock(), await _dayStartHour());

  // ---------------------------------------------------------------------------
  // Day generation

  /// Generates today's tasks from active templates. Idempotent: running it
  /// any number of times yields one task per (template, date).
  ///
  /// Days since the last generated day are back-filled (up to
  /// [maxBackfillDays]) so days the app wasn't opened still count as
  /// scheduled-but-missed in history and streaks.
  Future<LocalDate> ensureToday() async {
    final startHour = await _dayStartHour();
    final today = DayClock.logicalDate(_clock(), startHour);
    await _tasks.transaction(() async {
      final templates = await _tasks.templates();
      final latest = await _tasks.latestTaskDate();
      var from = today;
      if (latest != null && latest.isBefore(today)) {
        from = latest.addDays(1);
        final earliest = today.addDays(-maxBackfillDays);
        if (from.isBefore(earliest)) from = earliest;
      }
      for (var d = from; !d.isAfter(today); d = d.addDays(1)) {
        for (final t in templates) {
          if (_appliesOn(t, d, startHour)) {
            await _tasks.insertDailyTaskIfAbsent(_snapshot(t, d));
          }
        }
      }
    });
    return today;
  }

  bool _appliesOn(TaskTemplate t, LocalDate date, int startHour) {
    if (!t.isActive || t.isArchived || !t.repeat.appliesOn(date)) return false;
    final createdOn = DayClock.logicalDate(t.createdAt, startHour);
    return !date.isBefore(createdOn);
  }

  static DailyTask _snapshot(TaskTemplate t, LocalDate date) => DailyTask(
    templateId: t.id,
    date: date,
    name: t.name,
    target: t.target,
    unit: t.unit,
    step: t.step,
    type: t.type,
  );

  /// Writes the first-launch sample data exactly once.
  Future<bool> seedIfNeeded(SeedContent seed) async {
    final seeded = await _tasks.transaction(() async {
      if (await _settings.isSeeded()) return false;
      var order = 0;
      for (final t in seed.templates) {
        await _tasks.insertTemplate(
          t.copyWith(id: 0, sortOrder: order++, createdAt: _clock()),
        );
      }
      await _settings.saveProfile(seed.profile);
      await _settings.markSeeded();
      return true;
    });
    if (seeded) await ensureToday();
    return seeded;
  }

  // ---------------------------------------------------------------------------
  // Progress

  Future<ProgressResult> advance(
    int dailyTaskId, {
    EventSource source = EventSource.app,
    DateTime? at,
  }) => _mutate(
    dailyTaskId,
    (t, when) => ProgressRules.advance(t, at: when, source: source),
    at: at,
    source: source,
  );

  Future<ProgressResult> undo(int dailyTaskId, {DateTime? at}) => _mutate(
    dailyTaskId,
    (t, when) => ProgressRules.undo(t, at: when),
    at: at,
    source: EventSource.app,
  );

  Future<ProgressResult> setProgress(
    int dailyTaskId,
    int value, {
    DateTime? at,
  }) => _mutate(
    dailyTaskId,
    (t, when) => ProgressRules.setProgress(t, value, at: when),
    at: at,
    source: EventSource.app,
  );

  Future<ProgressResult> _mutate(
    int dailyTaskId,
    ProgressChange Function(DailyTask task, DateTime at) rule, {
    DateTime? at,
    required EventSource source,
  }) async {
    final when = at ?? _clock();
    final pending = <TaskEvent>[];
    final result = await _tasks.transaction(() async {
      final task = await _tasks.dailyTaskById(dailyTaskId);
      if (task == null) return ProgressResult.none;
      final change = rule(task, when);
      if (!change.changed) return ProgressResult(task: task);
      final event = await _apply(change);
      pending.add(event);
      final dayEvent = await _maybeCompleteDay(task.date, when, source);
      if (dayEvent != null) pending.add(dayEvent);
      return ProgressResult(
        task: change.task,
        event: event,
        dayCompleted: dayEvent != null,
      );
    });
    await _notify(pending);
    return result;
  }

  Future<TaskEvent> _apply(ProgressChange change) async {
    await _tasks.updateDailyTask(change.task);
    final event = change.event!;
    final id = await _tasks.insertEvent(event);
    return event.withId(id);
  }

  /// Writes the day's single `dayComplete` event the first time every task
  /// of [date] is complete.
  Future<TaskEvent?> _maybeCompleteDay(
    LocalDate date,
    DateTime at,
    EventSource source,
  ) async {
    final tasks = await _tasks.dailyTasksOn(date);
    if (tasks.isEmpty || tasks.any((t) => !t.isCompleted)) return null;
    if (await _tasks.hasDayComplete(date)) return null;
    final event = TaskEvent(
      dailyTaskId: null,
      templateId: null,
      date: date,
      delta: 0,
      newProgress: tasks.length,
      kind: EventKind.dayComplete,
      source: source,
      occurredAt: at,
    );
    return event.withId(await _tasks.insertEvent(event));
  }

  Future<void> _notify(List<TaskEvent> events) async {
    for (final e in events) {
      for (final hook in _hooks) {
        try {
          switch (e.kind) {
            case EventKind.progress || EventKind.undo:
              await hook.onProgress(e);
            case EventKind.complete:
              await hook.onProgress(e);
              await hook.onTaskCompleted(e);
            case EventKind.dayComplete:
              await hook.onDayCompleted(e.date.toDateTime());
          }
        } catch (error, stack) {
          _onHookError?.call(error, stack);
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Widget queue

  /// Merges check-ins queued by home-screen widgets. Returns the ids of the
  /// queue entries that were consumed (applied or discarded as stale) so the
  /// caller can remove exactly those from the shared queue.
  Future<Set<String>> applyWidgetEvents(List<PendingWidgetEvent> events) async {
    final consumed = <String>{};
    final ordered = [...events]
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    for (final e in ordered) {
      consumed.add(e.id);
      if (e.action != PendingWidgetEvent.actionAdvance) continue;
      final task = await _tasks.dailyTaskById(e.dailyTaskId);
      // Ids may be stale after a reset/import: require the date to match.
      if (task == null || task.date.toString() != e.date) continue;
      await advance(
        e.dailyTaskId,
        source: EventSource.widget,
        at: e.occurredAt,
      );
    }
    return consumed;
  }

  // ---------------------------------------------------------------------------
  // Templates

  Future<int> createTemplate(TaskTemplate template) async {
    _validate(template);
    final id = await _tasks.transaction(() async {
      final existing = await _tasks.templates(includeArchived: true);
      final maxOrder = existing.fold<int>(
        -1,
        (m, t) => t.sortOrder > m ? t.sortOrder : m,
      );
      return _tasks.insertTemplate(
        template.copyWith(
          id: 0,
          sortOrder: maxOrder + 1,
          createdAt: _clock(),
          archivedAt: () => null,
        ),
      );
    });
    await ensureToday();
    return id;
  }

  /// Whether today already has a generated task for [templateId] — the UI
  /// then asks whether an edit should be synced to it.
  Future<bool> hasTodayTask(int templateId) async =>
      await _tasks.dailyTaskFor(templateId, await today()) != null;

  /// Saves template edits. They apply to tasks generated from tomorrow on;
  /// with [syncToday] today's already generated task is updated as well.
  Future<void> updateTemplate(
    TaskTemplate template, {
    bool syncToday = false,
  }) async {
    _validate(template);
    final pending = <TaskEvent>[];
    final todayDate = await today();
    await _tasks.transaction(() async {
      final current = await _tasks.templateById(template.id);
      if (current == null) throw StateError('Unknown template ${template.id}');
      await _tasks.updateTemplate(
        template.copyWith(
          createdAt: current.createdAt,
          archivedAt: () => current.archivedAt,
        ),
      );
      if (!syncToday) return;
      final task = await _tasks.dailyTaskFor(template.id, todayDate);
      if (task == null) return;
      final change = ProgressRules.resnapshot(task, template, at: _clock());
      if (change.changed) {
        pending.add(await _apply(change));
      } else {
        await _tasks.updateDailyTask(change.task);
      }
      final dayEvent = await _maybeCompleteDay(
        todayDate,
        _clock(),
        EventSource.app,
      );
      if (dayEvent != null) pending.add(dayEvent);
    });
    await _notify(pending);
    await ensureToday();
  }

  /// Pauses or resumes a template. Pausing removes today's task if it
  /// hasn't been touched yet.
  Future<void> setTemplateActive(int templateId, bool active) async {
    await _tasks.transaction(() async {
      final t = await _tasks.templateById(templateId);
      if (t == null) return;
      await _tasks.updateTemplate(t.copyWith(isActive: active));
      if (!active) await _removeUntouchedToday(templateId);
    });
    await ensureToday();
  }

  /// Soft-deletes a template; its history stays in stats.
  Future<void> archiveTemplate(int templateId) async {
    await _tasks.transaction(() async {
      final t = await _tasks.templateById(templateId);
      if (t == null) return;
      await _tasks.updateTemplate(t.copyWith(archivedAt: () => _clock()));
      await _removeUntouchedToday(templateId);
    });
  }

  Future<void> _removeUntouchedToday(int templateId) async {
    final task = await _tasks.dailyTaskFor(templateId, await today());
    if (task == null || task.progress > 0) return;
    if (await _tasks.eventCountForDailyTask(task.id) > 0) return;
    await _tasks.deleteDailyTask(task.id);
  }

  /// Persists a new order (index in [orderedIds] becomes the sort order).
  Future<void> reorderTemplates(List<int> orderedIds) =>
      _tasks.updateSortOrders({
        for (var i = 0; i < orderedIds.length; i++) orderedIds[i]: i,
      });

  void _validate(TaskTemplate t) {
    final errors = TemplateValidation.validateTemplate(t);
    if (errors.isNotEmpty) throw TemplateValidationException(errors);
  }
}
