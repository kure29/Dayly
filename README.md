# 每日任务 Daily Quest

一个简洁的「今日任务工作台」：设置每天要做的事（背 100 个单词、做 1 套题、阅读 30 分钟……），打开就能看到今天做到哪了，也可以直接在桌面小组件上打卡。

- Flutter（iOS + Android），两端统一的苹果简洁风格（不使用 Material 默认外观）
- 纯本地：SQLite（drift），无后端、无登录
- 浅色 / 深色 / 跟随系统；5 套内置配色 + 自定义主题色
- 桌面小组件：小号 / 中号（直接打卡）/ 大号，iOS 锁屏圆形与矩形
- 第一版不含游戏化，但预留了独立「游戏层」的扩展点（见下文）

## 目录结构

```
lib/
  app/                 # 组装层：Riverpod providers、路由、启动、生命周期
  core/theme/          # 设计令牌、AppPalette(ThemeExtension)、ThemeRegistry、自定义配色
  core/l10n/           # ARB（zh 默认、en）与生成代码
  core/ui/             # 通用组件：分组列表、胶囊按钮、毛玻璃标签栏、底部面板、顶部胶囊提示…
  data/                # drift 表、DAO、Repository 实现
  domain/              # 纯 Dart 业务逻辑（不依赖 Flutter）：模型、规则、统计、TaskService
  domain/hooks/        # ProgressHook 扩展点、EventReplayer
  features/today/      # 今日页
  features/stats/      # 统计页
  features/settings/   # 我的 / 设置、任务管理、备份、提醒、主题预览
  features/task_editor/# 任务编辑器与内置模板
  widgets_bridge/      # 与原生小组件同步（快照、待处理队列、Android 后台回调）
assets/themes/         # 配色方案 JSON
android/app/src/main/kotlin/.../widget/   # Android 小组件（RemoteViews）
ios/DailyQuestWidget/  # iOS WidgetKit 扩展源码
docs/ios-widget-setup.md
```

## 运行与构建

需要 Flutter 3.47+（Dart 3.13+）。

```bash
flutter pub get
flutter run                      # 选择设备
flutter build apk --debug        # Android 调试包
flutter build ios                # 需要 macOS；小组件需先按 docs/ios-widget-setup.md 在 Xcode 中配置
```

质量检查：

```bash
flutter analyze                  # 零警告
dart format --set-exit-if-changed lib test
flutter test                     # 单元测试 + Widget 测试
```

修改 drift 表或 ARB 后重新生成代码：

```bash
dart run build_runner build      # drift (*.g.dart)
flutter gen-l10n                 # 本地化
```

### 数据库迁移

`AppDatabase.schemaVersion` 当前为 1，`drift_schemas/` 中保存了每个版本的结构快照。修改表结构时：

1. 修改 `lib/data/tables.dart`，把 `schemaVersion` 加 1；
2. 在 `AppDatabase._migrateTo` 中为新版本添加一个 `case`；
3. 运行 `dart run drift_dev make-migrations` 生成新快照与迁移测试骨架（位于 `test/drift/`）。

## 设计系统

- 所有颜色通过 `context.palette`（`AppPalette`，一个 `ThemeExtension`）读取，组件中不硬编码颜色。
- 中性色令牌在 `core/theme/design_tokens.dart`，字号层级：大标题 34 粗体、标题 20、正文 17、注释 13。
- 「我的 ▸ 关于 ▸ 主题预览」页面列出全部令牌、对比度、字号与组件，用于自检。
- `test/core/theme_contrast_test.dart` 为每套方案（以及自定义主题色的整圈色相）验证：文字 ≥ 4.5:1，进度环等图形 ≥ 3:1，胶囊按钮浅色底上的强调色文字 ≥ 4.5:1。

### 如何新增配色方案

只需新增一个 JSON 文件，不用改代码：

1. 在 `assets/themes/` 新建 `my_scheme.json`：

   ```json
   {
     "schemaVersion": 1,
     "id": "my_scheme",
     "order": 5,
     "name": { "zh": "我的配色", "en": "My Scheme" },
     "light": {
       "accent": "#0062CC", "ring": "#007AFF", "success": "#248A3D",
       "tasks": ["#FF3B30", "#FF9500", "#FFCC00", "#34C759", "#30B0C7", "#007AFF", "#5856D6", "#FF2D55"]
     },
     "dark": {
       "accent": "#5AA9FF", "ring": "#0A84FF", "success": "#30D158",
       "tasks": ["#FF453A", "#FF9F0A", "#FFD60A", "#30D158", "#40C8E0", "#0A84FF", "#5E5CE6", "#FF375F"]
     }
   }
   ```

   - `accent`：按钮、链接等强调色（作为文字使用，需 ≥ 4.5:1）
   - `ring`：今日进度环；`success`：完成状态
   - `tasks`：恰好 8 个任务色（图标上的字符颜色会自动选黑/白）
   - `order` 决定在选择器中的位置
2. 运行 `flutter test test/core/theme_contrast_test.dart`，对比度不达标会给出具体是哪一项。

`ThemeRegistry` 通过 Asset Manifest 自动发现 `assets/themes/` 下的所有 JSON。同样的 JSON 结构也可以通过 `ThemeRegistry.fromJsonList` / `merge` 从远程配置下发；`schemaVersion` 高于当前支持版本的方案会被拒绝。

## 业务规则概要

- 所有任务状态变更只能经由 `domain/task_service.dart` 中的 `TaskService`：它在同一事务中更新数据并写入 `TaskEvent`，提交后再通知所有 `ProgressHook`。
- 推进：`progress += step`，不超过 `target`；达到目标写 `complete` 事件并记录 `completedAt`。撤销每次减一步，写 `undo` 事件，离开完成状态时清空 `completedAt`。长按输入数值同样生成相应事件。
- 当天全部完成时写入一条 `dayComplete`（每天最多一条），并显示一个简洁的提示。
- 日期按 `dayStartHour`（默认 4 点）切分：凌晨 4 点前仍属于前一天。
- 每天的任务由模板生成，按 (模板, 日期) 唯一，生成过程幂等；同时保存名称、目标、单位、步长的快照，修改模板只影响之后生成的任务，今天的任务会询问「是否同步到今天」。
- 连续天数：全部完成的一天 +1，有任务但未完成的一天归零；没有任务的日子不中断；今天尚未完成时不会打断连续。

## 如何接入游戏层

第一版没有任何游戏化内容，但架构为一个独立的游戏模块（角色、经验、金币、装备……）预留了扩展点：

1. **事件日志是唯一事实来源。** 每次推进、完成、撤销以及每日全部完成都会写入一条 `TaskEvent`（`kind` = `progress` / `complete` / `undo` / `dayComplete`，`source` = `app` / `widget`，带 `delta`、`newProgress`、`occurredAt`）。事件只追加，不修改。
2. **实现 `ProgressHook`**（`lib/domain/hooks/progress_hook.dart`）：

   ```dart
   class GameHook extends ProgressHook {
     GameHook(this.game);
     final GameService game;

     @override
     Future<void> onProgress(TaskEvent e) => game.grantXp(e);        // 撤销时 delta 为负

     @override
     Future<void> onTaskCompleted(TaskEvent e) => game.rollLoot(e);

     @override
     Future<void> onDayCompleted(DateTime day) => game.dailyBonus(day);
   }
   ```

   调用时机：数据库事务提交之后；`onProgress` 对每个 progress / complete / undo 事件调用，`complete` 事件额外调用 `onTaskCompleted`，`dayComplete` 调用 `onDayCompleted`。hook 抛出的异常会被捕获并上报，不会影响打卡本身。
3. **注册 hook**：在游戏模块中覆盖 `progressHooksProvider`（`lib/app/providers.dart`），例如在 `bootstrap()` 的 `overrides` 中：

   ```dart
   progressHooksProvider.overrideWith((ref) => [
     const NoopProgressHook(),
     GameHook(ref.watch(gameServiceProvider)),
   ]),
   ```
4. **补发历史奖励**：游戏层首次安装时，用 `EventReplayer.replay(await taskRepository.allEvents(), gameHook)` 按时间顺序重放全部历史事件，即可计算出过去应得的奖励。
5. **注意幂等**：撤销后重新完成会再次产生 `complete` 事件，游戏层应自行去重（例如每个 `dailyTaskId` 只奖励一次完成，或按 `undo` 事件扣回）。`dayComplete` 每天最多一条，可直接使用。
6. 游戏层应保存自己的数据表（新的 drift 表或独立数据库），不要修改任务相关的表；如需展示，在 `features/` 下新增独立的页面与标签即可。

## 桌面小组件

- App 每次数据变化都会把一个带版本号的 JSON 快照（`dq_snapshot`）写入共享存储（Android SharedPreferences / iOS App Group），并刷新小组件。快照中包含当前配色方案的浅色与深色两套颜色，小组件据此跟随 App 配色与系统深浅色。
- 在小组件上打卡不会直接写数据库：它把事件追加到共享队列 `dq_pending`，并乐观地更新快照让小组件立刻变化；App 下次启动或回到前台时把队列合并进数据库，生成 `source = widget` 的 `TaskEvent`（只移除已合并的条目，合并期间新增的打卡不会丢失）。
- Android：`android/app/src/main/kotlin/com/example/dailyquest/widget/`，基于 home_widget 的 `HomeWidgetProvider`（RemoteViews）。「+」按钮触发 home_widget 的后台回调（`lib/widgets_bridge/widget_callback.dart`）。Android 12+ 上颜色以浅/深两套值下发，由桌面随系统切换。
- iOS：`ios/DailyQuestWidget/`，iOS 17+ 通过 AppIntent 按钮直接打卡，iOS 16 点击会打开 App。Xcode 中需要的手动步骤见 [docs/ios-widget-setup.md](docs/ios-widget-setup.md)。
- 逻辑日结束后（过了 `dayStartHour`），小组件显示「打开 App 开始新的一天」，直到 App 生成新一天的任务。

## 数据

- 「我的 ▸ 数据」可以导出 JSON 备份（系统分享面板）、导入备份（覆盖当前数据）或重置。
- 备份格式见 `lib/domain/backup.dart`（`formatVersion: 1`），包含资料、设置、模板、每日任务与全部事件；导入前会校验格式与引用关系。
