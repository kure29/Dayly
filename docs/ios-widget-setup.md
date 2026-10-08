# iOS 小组件配置指南（Xcode 手动步骤）

仓库里已经包含 iOS 小组件扩展的全部源码，但「添加 Target、App Group、签名」这类操作必须在 macOS 上用 Xcode 完成（本项目在 Linux 上开发，无法生成/验证 Xcode 工程中的这部分配置）。按下面的步骤操作一次即可。

> 需要：macOS + Xcode 15 或更高（交互式小组件需要 iOS 17 SDK），一个可用的 Apple 开发者账号（App Group 需要在开发者后台注册）。

## 0. 已经准备好的文件

| 文件 | 作用 |
| --- | --- |
| `ios/DailyQuestWidget/DailyQuestWidget.swift` | WidgetBundle、TimelineProvider、小/中/大号与锁屏圆形/矩形视图 |
| `ios/DailyQuestWidget/SharedStore.swift` | 与 Flutter 共享的数据模型（快照 JSON、待处理事件队列）及读写 |
| `ios/DailyQuestWidget/CheckInIntent.swift` | iOS 17+ 的 AppIntent，小组件上的「+」按钮 |
| `ios/DailyQuestWidget/Info.plist` | 扩展的 Info.plist（`com.apple.widgetkit-extension`） |
| `ios/DailyQuestWidget/DailyQuestWidget.entitlements` | 扩展的 App Group 权限 |
| `ios/Runner/Runner.entitlements` | 主 App 的 App Group 权限 |

数据约定（与 Dart 侧 `lib/widgets_bridge/widget_snapshot.dart` 保持一致）：

- App Group：`group.com.example.dailyquest`
- `dq_snapshot`：今日快照 JSON（进度、任务、浅/深色配色）
- `dq_pending`：小组件打卡的待处理事件队列 JSON
- 小组件 kind：`DailyQuestWidget`（Dart 中 `WidgetKeys.iOSKind`）

## 1. 打开工程

```bash
flutter pub get
cd ios && pod install   # 若使用 Swift Package Manager 可跳过
open Runner.xcworkspace
```

## 2. 添加 Widget Extension Target

1. Xcode 菜单 **File ▸ New ▸ Target…**，选择 **iOS ▸ Widget Extension**，点 **Next**。
2. 填写：
   - **Product Name**：`DailyQuestWidget`（必须与目录名一致）
   - **Team**：选择你的开发团队
   - **Bundle Identifier**：会自动成为 `com.example.dailyquest.DailyQuestWidget`
   - 取消勾选 **Include Live Activity** 和 **Include Configuration App Intent**
3. 点 **Finish**；弹出 “Activate scheme?” 时选 **Activate**（之后可切回 Runner）。
4. Xcode 会在 `ios/DailyQuestWidget/` 生成模板文件，并且可能**覆盖同名文件**。处理方式：
   - 在 Xcode 左侧删除自动生成的 `DailyQuestWidget.swift`、`DailyQuestWidgetBundle.swift`、`AppIntent.swift`、`DailyQuestWidgetLiveActivity.swift`（如果有）—— 选择 **Move to Trash**。
   - 用 git 恢复仓库中的版本：`git checkout -- ios/DailyQuestWidget/`
   - 右键 `DailyQuestWidget` 组 ▸ **Add Files to "Runner"…**，选中 `DailyQuestWidget.swift`、`SharedStore.swift`、`CheckInIntent.swift`，**Target Membership 只勾选 `DailyQuestWidget`**。
   - `Assets.xcassets` 保留 Xcode 生成的即可。
5. 选中 `DailyQuestWidget` target ▸ **Build Settings**：
   - **Info.plist File**：`DailyQuestWidget/Info.plist`
   - **Code Signing Entitlements**：`DailyQuestWidget/DailyQuestWidget.entitlements`
   - **iOS Deployment Target**：`16.0`（锁屏小组件需要 16；交互按钮在 17+ 自动启用，16 上点击「+」会打开 App）
   - **Swift Language Version**：Swift 5 或更高
6. **General ▸ Frameworks and Libraries**：确认已链接 `WidgetKit.framework`、`SwiftUI.framework`（模板默认已加）。

## 3. 配置 App Group（主 App 与扩展都要做）

1. 选中 **Runner** target ▸ **Signing & Capabilities** ▸ **+ Capability** ▸ **App Groups**。
2. 点 **+**，添加 `group.com.example.dailyquest` 并勾选。
   - Xcode 会把权限写入 `Runner/Runner.entitlements`（仓库已提供同名文件，内容一致即可）。
   - 确认 **Build Settings ▸ Code Signing Entitlements** = `Runner/Runner.entitlements`（Debug / Release / Profile 三个配置都要）。
3. 选中 **DailyQuestWidget** target，重复上面两步，勾选同一个 `group.com.example.dailyquest`。
4. 如果你修改了包名/Group 名，需要同时修改：
   - `lib/widgets_bridge/widget_snapshot.dart` 中的 `WidgetKeys.appGroupId`
   - `ios/DailyQuestWidget/SharedStore.swift` 中的 `SharedStore.appGroup`
   - 两个 `.entitlements` 文件

## 4. 签名

1. **Runner** 与 **DailyQuestWidget** 两个 target 的 **Signing & Capabilities** 中都选同一个 **Team**，勾选 **Automatically manage signing**。
2. 扩展的 Bundle ID 必须以主 App 的 Bundle ID 为前缀：`com.example.dailyquest.DailyQuestWidget`。
3. 发布前请把 `com.example` 换成你自己的反向域名（主 App、扩展、App Group 一起改）。

## 5. 让 Flutter 构建包含扩展

1. 选中 **Runner** target ▸ **Build Phases**：
   - 确认存在 **Embed Foundation Extensions**（或 **Embed App Extensions**）阶段，并包含 `DailyQuestWidget.appex`（添加 Target 时 Xcode 通常会自动创建）。
   - 将 **Embed Foundation Extensions** 拖到 **Thin Binary** 和 **Run Script**（Flutter 的 `xcode_backend.sh`）**之前**，否则可能出现 *Cycle inside Runner* 构建错误。
2. 扩展的 **Build Settings ▸ Versioning**（可选）：把 `MARKETING_VERSION` 设为 `$(FLUTTER_BUILD_NAME)`、`CURRENT_PROJECT_VERSION` 设为 `$(FLUTTER_BUILD_NUMBER)`，与主 App 保持一致（Info.plist 已引用这两个变量）。
3. 如果使用 CocoaPods，在 `ios/Podfile` 中**不需要**为扩展添加 target（扩展不依赖任何 Pod）。

## 6. 运行与验证

```bash
flutter run   # 选择 iOS 17+ 模拟器或真机
```

1. 打开 App，等待今日页加载（App 会把快照写入 App Group 并调用 `WidgetCenter` 刷新）。
2. 回到主屏幕，长按 ▸ 左上角 **+** ▸ 搜索「每日任务」，添加小 / 中 / 大号小组件；锁屏编辑中添加圆形与矩形组件。
3. 在中号小组件上点「+」：进度立即增加（乐观更新），事件写入 `dq_pending` 队列。
4. 回到 App：前台恢复时会合并队列，生成 `source = widget` 的 TaskEvent，今日页与统计同步更新。
5. 切换 App 内配色方案或深浅色模式，小组件随之更新；「跟随系统」时小组件跟随系统深浅色。

## 7. 常见问题

| 现象 | 处理 |
| --- | --- |
| 小组件一直显示空白/占位 | App Group 未在两个 target 上同时启用，或 Group 名不一致；检查第 3 步。 |
| `Cycle inside Runner; building could produce unreliable results` | 第 5 步：把 Embed Foundation Extensions 移到 Run Script 之前。 |
| 点击「+」打开了 App 而不是直接打卡 | 设备系统低于 iOS 17，属预期行为。 |
| 签名报错 *No profiles for 'com.example.dailyquest.DailyQuestWidget'* | 为扩展选择 Team 并开启自动签名；或在开发者后台为该 Bundle ID 创建描述文件。 |
| 修改 Swift 后小组件没变化 | 删除已添加的小组件后重新添加，或在 Xcode 中单独运行 `DailyQuestWidget` scheme。 |
