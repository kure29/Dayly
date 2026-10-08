import 'package:dailyquest/domain/hooks/progress_hook.dart';
import 'package:dailyquest/domain/models.dart';
import 'package:dailyquest/domain/task_service.dart';
import 'package:dailyquest/domain/template_validation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_env.dart';

void main() {
  late TestEnv env;
  final oct8 = LocalDate(2026, 10, 8); // Thursday
  final oct9 = LocalDate(2026, 10, 9);

  setUp(() => env = TestEnv(now: DateTime(2026, 10, 8, 9)));
  tearDown(() => env.dispose());

  group('day generation', () {
    test('is idempotent', () async {
      await env.addTemplate(name: '背单词');
      await env.addTemplate(name: '阅读', target: 30, unit: '分钟');
      for (var i = 0; i < 5; i++) {
        await env.service.ensureToday();
      }
      final tasks = await env.tasksOn(oct8);
      expect(tasks, hasLength(2));
      expect(tasks.map((t) => t.name), containsAll(['背单词', '阅读']));
    });

    test('concurrent calls still produce one task per template', () async {
      await env.addTemplate();
      await Future.wait([
        for (var i = 0; i < 4; i++) env.service.ensureToday(),
      ]);
      expect(await env.tasksOn(oct8), hasLength(1));
    });

    test('snapshots name, target and unit', () async {
      final id = await env.addTemplate(name: '背单词', target: 100, unit: '个');
      final t = await env.taskFor(id, oct8);
      expect((t.name, t.target, t.unit, t.step), ('背单词', 100, '个', 10));
    });

    test('respects repeat rules and paused templates', () async {
      await env.addTemplate(name: 'daily');
      await env.addTemplate(
        name: 'workdays',
        repeat: const RepeatRule.weekdays(),
      );
      await env.addTemplate(name: 'sat', repeat: RepeatRule.custom([6]));
      final paused = await env.addTemplate(name: 'paused');
      await env.service.setTemplateActive(paused, false);

      expect((await env.tasksOn(oct8)).map((t) => t.name).toSet(), {
        'daily',
        'workdays',
      });
      env.clock.now = DateTime(2026, 10, 10, 9); // Saturday
      await env.service.ensureToday();
      expect(
        (await env.tasksOn(LocalDate(2026, 10, 10))).map((t) => t.name).toSet(),
        {'daily', 'sat'},
      );
    });

    test('back-fills days the app was not opened', () async {
      final id = await env.addTemplate();
      env.clock.now = DateTime(2026, 10, 11, 9);
      await env.service.ensureToday();
      for (final d in [8, 9, 10, 11]) {
        final t = await env.tasks.dailyTaskFor(id, LocalDate(2026, 10, d));
        expect(t, isNotNull, reason: 'day $d');
        expect(t!.progress, 0);
      }
    });

    test('does not generate days before the template existed', () async {
      env.clock.now = DateTime(2026, 10, 10, 9);
      final id = await env.addTemplate();
      expect(await env.tasks.dailyTaskFor(id, oct9), isNull);
    });
  });

  group('dayStartHour', () {
    test('check-ins before the cut-over count for the previous day', () async {
      final id = await env.addTemplate();
      env.clock.now = DateTime(2026, 10, 9, 3, 30);
      expect(await env.service.ensureToday(), oct8);
      final task = await env.taskFor(id, oct8);
      await env.service.advance(task.id);
      expect((await env.taskFor(id, oct8)).progress, 10);
      expect(await env.tasks.dailyTaskFor(id, oct9), isNull);

      env.clock.now = DateTime(2026, 10, 9, 4);
      expect(await env.service.ensureToday(), oct9);
      expect((await env.taskFor(id, oct9)).progress, 0);
    });

    test('honours a custom dayStartHour', () async {
      await env.settings.saveSettings(const AppSettings(dayStartHour: 6));
      env.clock.now = DateTime(2026, 10, 9, 5, 59);
      expect(await env.service.today(), oct8);
      env.clock.now = DateTime(2026, 10, 9, 6);
      expect(await env.service.today(), oct9);
    });
  });

  group('progress', () {
    test('advance and undo write events and notify hooks', () async {
      final id = await env.addTemplate(target: 20, step: 10);
      final task = await env.taskFor(id, oct8);

      final r1 = await env.service.advance(task.id);
      expect(r1.event!.kind, EventKind.progress);
      final r2 = await env.service.advance(task.id);
      expect(r2.taskCompleted, isTrue);
      expect(r2.task!.completedAt, env.clock.now);
      final r3 = await env.service.undo(task.id);
      expect(r3.event!.kind, EventKind.undo);
      expect(r3.task!.completedAt, isNull);

      final kinds = (await env.events()).map((e) => e.kind).toList();
      expect(kinds, [
        EventKind.progress,
        EventKind.complete,
        EventKind.dayComplete,
        EventKind.undo,
      ]);
      expect(env.hook.progress, hasLength(3));
      expect(env.hook.completed, hasLength(1));
      expect(env.hook.days, [DateTime(2026, 10, 8)]);
    });

    test('dayComplete is written only once per day', () async {
      final a = await env.addTemplate(name: 'a', target: 1, step: 1);
      final b = await env.addTemplate(name: 'b', target: 1, step: 1);
      final ta = await env.taskFor(a, oct8);
      final tb = await env.taskFor(b, oct8);

      expect((await env.service.advance(ta.id)).dayCompleted, isFalse);
      expect((await env.service.advance(tb.id)).dayCompleted, isTrue);
      await env.service.undo(tb.id);
      expect((await env.service.advance(tb.id)).dayCompleted, isFalse);
      await env.service.undo(ta.id);
      await env.service.advance(ta.id);

      final dayEvents = (await env.events()).where(
        (e) => e.kind == EventKind.dayComplete,
      );
      expect(dayEvents, hasLength(1));
      expect(dayEvents.single.date, oct8);
      expect(env.hook.days, hasLength(1));
    });

    test('setProgress via long-press input', () async {
      final id = await env.addTemplate();
      final task = await env.taskFor(id, oct8);
      final r = await env.service.setProgress(task.id, 70);
      expect(r.task!.progress, 70);
      expect(r.event!.delta, 70);
      expect((await env.service.setProgress(task.id, 70)).changed, isFalse);
    });

    test('a failing hook never breaks a check-in', () async {
      final errors = <Object>[];
      final service = TaskService(
        tasks: env.tasks,
        settings: env.settings,
        hooks: [_ThrowingHook(), env.hook],
        clock: env.clock.call,
        onHookError: (e, _) => errors.add(e),
      );
      final id = await env.addTemplate();
      final task = await env.taskFor(id, oct8);
      final r = await service.advance(task.id);
      expect(r.task!.progress, 10);
      expect(errors, isNotEmpty);
      expect(env.hook.progress, hasLength(1));
    });
  });

  group('template edits', () {
    TaskTemplate edited(TaskTemplate t) =>
        t.copyWith(name: '背单词+', target: 50, step: 5, unit: '词');

    test('without sync only affect future days', () async {
      final id = await env.addTemplate();
      final tpl = (await env.tasks.templateById(id))!;
      expect(await env.service.hasTodayTask(id), isTrue);
      await env.service.updateTemplate(edited(tpl));

      final today = await env.taskFor(id, oct8);
      expect((today.name, today.target, today.unit), ('背单词', 100, '个'));

      env.clock.now = DateTime(2026, 10, 9, 9);
      await env.service.ensureToday();
      final tomorrow = await env.taskFor(id, oct9);
      expect(
        (tomorrow.name, tomorrow.target, tomorrow.unit),
        ('背单词+', 50, '词'),
      );
    });

    test('with sync update today and re-evaluate completion', () async {
      final id = await env.addTemplate();
      final task = await env.taskFor(id, oct8);
      await env.service.setProgress(task.id, 60);
      final tpl = (await env.tasks.templateById(id))!;
      await env.service.updateTemplate(edited(tpl), syncToday: true);

      final today = await env.taskFor(id, oct8);
      expect((today.name, today.target, today.progress), ('背单词+', 50, 50));
      expect(today.isCompleted, isTrue);
      final last = (await env.events()).where((e) => e.dailyTaskId == task.id);
      expect(last.last.kind, EventKind.complete);
    });

    test('validation rejects bad templates', () async {
      expect(
        () => env.addTemplate(name: ''),
        throwsA(isA<TemplateValidationException>()),
      );
      expect(
        () => env.addTemplate(target: 10, step: 11),
        throwsA(isA<TemplateValidationException>()),
      );
      expect(
        TemplateValidation.validate(
          name: '一二三四五六七八九十一二三四五六七八九十',
          target: 1,
          step: 1,
          repeat: const RepeatRule.daily(),
        ),
        isEmpty,
      );
      expect(
        TemplateValidation.validate(
          name: '一二三四五六七八九十一二三四五六七八九十一',
          target: 0,
          step: 0,
          repeat: RepeatRule.custom(const []),
        ),
        {
          TemplateError.nameLength,
          TemplateError.target,
          TemplateError.step,
          TemplateError.repeat,
        },
      );
    });

    test(
      'archiving removes an untouched today task but keeps history',
      () async {
        final keep = await env.addTemplate(name: 'touched');
        final drop = await env.addTemplate(name: 'untouched');
        await env.service.advance((await env.taskFor(keep, oct8)).id);
        await env.service.archiveTemplate(keep);
        await env.service.archiveTemplate(drop);
        expect((await env.tasksOn(oct8)).map((t) => t.name), ['touched']);
        expect(await env.tasks.templates(), isEmpty);
        expect(await env.tasks.templates(includeArchived: true), hasLength(2));
      },
    );

    test('reorder persists sort order', () async {
      final a = await env.addTemplate(name: 'a');
      final b = await env.addTemplate(name: 'b');
      final c = await env.addTemplate(name: 'c');
      await env.service.reorderTemplates([c, a, b]);
      expect((await env.tasks.templates()).map((t) => t.name), ['c', 'a', 'b']);
      final today = await env.tasks.watchTodayTasks(oct8).first;
      expect(today.map((t) => t.task.name), ['c', 'a', 'b']);
    });
  });

  test('seeding happens exactly once', () async {
    final seed = SeedContent(
      profile: const Profile(nickname: '小明', avatarChar: '明'),
      templates: [
        TaskTemplate(
          name: '背单词',
          icon: 'sym:book',
          colorIndex: 0,
          type: TaskType.count,
          target: 100,
          step: 10,
          unit: '个',
          createdAt: DateTime(2000),
        ),
      ],
    );
    expect(await env.service.seedIfNeeded(seed), isTrue);
    expect(await env.service.seedIfNeeded(seed), isFalse);
    expect(await env.tasks.templates(), hasLength(1));
    expect(await env.tasksOn(oct8), hasLength(1));
    expect((await env.settings.loadProfile()).nickname, '小明');
  });

  test('event history can be replayed into a late-registered hook', () async {
    final id = await env.addTemplate(target: 20, step: 10);
    final task = await env.taskFor(id, oct8);
    await env.service.advance(task.id);
    await env.service.advance(task.id);
    final late = RecordingHook();
    await EventReplayer.replay(await env.events(), late);
    expect(late.progress.length, env.hook.progress.length);
    expect(late.completed.length, env.hook.completed.length);
    expect(late.days, env.hook.days);
  });
}

class _ThrowingHook extends ProgressHook {
  @override
  void onProgress(TaskEvent e) => throw StateError('boom');

  @override
  void onTaskCompleted(TaskEvent e) => throw StateError('boom');

  @override
  void onDayCompleted(DateTime day) => throw StateError('boom');
}
