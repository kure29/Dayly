import 'package:dailyquest/app/bootstrap.dart';
import 'package:dailyquest/app/providers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_env.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bootstrap completes on a fresh database', () async {
    final env = TestEnv();
    addTearDown(env.dispose);
    final container = await bootstrap(
      overrides: [databaseProvider.overrideWithValue(env.db)],
    ).timeout(const Duration(seconds: 10));
    addTearDown(container.dispose);
    expect(await env.tasks.templates(), hasLength(4));
  });
}
