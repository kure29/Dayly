import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/settings/manage_tasks_page.dart';
import '../features/settings/me_page.dart';
import '../features/settings/theme_preview_page.dart';
import '../features/stats/stats_page.dart';
import '../features/task_editor/task_editor_page.dart';
import '../features/today/today_page.dart';
import 'home_shell.dart';

abstract final class Routes {
  static const today = '/today';
  static const stats = '/stats';
  static const me = '/me';
  static const themePreview = '/me/theme-preview';
  static const manageTasks = '/me/tasks';
  static const newTask = '/editor';
  static String editTask(int templateId) => '/editor/$templateId';
}

final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.today,
    routes: [
      GoRoute(
        path: Routes.newTask,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const MaterialPage(fullscreenDialog: true, child: TaskEditorPage()),
        routes: [
          GoRoute(
            path: ':id',
            parentNavigatorKey: rootNavigatorKey,
            pageBuilder: (context, state) => MaterialPage(
              fullscreenDialog: true,
              child: TaskEditorPage(
                templateId: int.parse(state.pathParameters['id']!),
              ),
            ),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.today,
                builder: (context, state) => const TodayPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.stats,
                builder: (context, state) => const StatsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.me,
                builder: (context, state) => const MePage(),
                routes: [
                  GoRoute(
                    path: 'tasks',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const ManageTasksPage(),
                  ),
                  GoRoute(
                    path: 'theme-preview',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const ThemePreviewPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
