import 'package:dailyquest/domain/models.dart';
import 'package:dailyquest/features/task_editor/task_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_env.dart';

void main() {
  Future<void> openEditor(WidgetTester tester, TestEnv env, {int? id}) async {
    await pumpScreen(
      tester,
      env,
      Builder(
        builder: (context) => Center(
          child: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => TaskEditorPage(templateId: id),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Finder field(String key) => find.descendant(
    of: find.byKey(ValueKey(key)),
    matching: find.byType(EditableText),
  );

  testWidgets('validates name, target and step', (tester) async {
    final env = TestEnv();
    await openEditor(tester, env);

    await tester.tap(find.byKey(const ValueKey('editor-save')));
    await tester.pumpAndSettle();
    expect(find.text('名称需为 1–20 个字'), findsOneWidget);

    await tester.enterText(field('field-name'), '一二三四五六七八九十一二三四五六七八九十一');
    await tester.pumpAndSettle();
    expect(find.text('名称需为 1–20 个字'), findsOneWidget);

    await tester.enterText(field('field-name'), '背单词');
    await tester.enterText(field('field-target'), '0');
    await tester.pumpAndSettle();
    expect(find.text('名称需为 1–20 个字'), findsNothing);
    expect(find.text('目标至少为 1'), findsOneWidget);

    await tester.enterText(field('field-target'), '10');
    await tester.enterText(field('field-step'), '20');
    await tester.pumpAndSettle();
    expect(find.text('目标至少为 1'), findsNothing);
    expect(find.text('每次打卡需在 1 与目标之间'), findsOneWidget);

    await tester.enterText(field('field-step'), '5');
    await tester.pumpAndSettle();
    expect(find.text('每次打卡需在 1 与目标之间'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('editor-save')));
    await tester.pumpAndSettle();
    expect(find.text('open'), findsOneWidget, reason: 'editor closed');

    final templates = (await tester.runAsync(env.tasks.templates))!;
    expect(templates.single.name, '背单词');
    expect((templates.single.target, templates.single.step), (10, 5));
    await unmountAndClose(tester, env);
  });

  testWidgets('built-in template fills the form', (tester) async {
    final env = TestEnv();
    await openEditor(tester, env);
    await tester.tap(find.byKey(const ValueKey('builtin-2')));
    await tester.pumpAndSettle();
    String text(String key) =>
        tester.widget<EditableText>(field(key)).controller.text;
    expect(text('field-name'), '阅读');
    expect(text('field-target'), '30');
    expect(text('field-step'), '10');
    expect(text('field-unit'), '分钟');
    await tester.tap(find.byKey(const ValueKey('editor-save')));
    await tester.pumpAndSettle();
    final t = (await tester.runAsync(env.tasks.templates))!.single;
    expect(
      (t.name, t.type, t.target, t.step),
      ('阅读', TaskType.duration, 30, 10),
    );
    await unmountAndClose(tester, env);
  });

  testWidgets('editing a task with a today instance asks to sync', (
    tester,
  ) async {
    final env = TestEnv();
    final id = (await tester.runAsync(() => env.addTemplate(name: '背单词')))!;
    await openEditor(tester, env, id: id);
    expect(find.text('编辑任务'), findsOneWidget);

    await tester.enterText(field('field-target'), '50');
    await tester.tap(find.byKey(const ValueKey('editor-save')));
    await tester.pumpAndSettle();
    expect(find.text('同步到今天？'), findsOneWidget);
    await tester.tap(find.text('同步到今天'));
    await tester.pumpAndSettle();

    final today = (await tester.runAsync(
      () => env.taskFor(id, LocalDate(2026, 10, 8)),
    ))!;
    expect(today.target, 50);
    await unmountAndClose(tester, env);
  });
}
