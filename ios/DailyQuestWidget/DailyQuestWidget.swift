import SwiftUI
import WidgetKit

// MARK: - Timeline

struct DailyQuestEntry: TimelineEntry {
    let date: Date
    let snapshot: Snapshot?

    var isStale: Bool { snapshot?.isStale(at: date) ?? true }
}

struct DailyQuestProvider: TimelineProvider {
    func placeholder(in context: Context) -> DailyQuestEntry {
        DailyQuestEntry(date: Date(), snapshot: .preview)
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyQuestEntry) -> Void) {
        completion(DailyQuestEntry(date: Date(), snapshot: SharedStore.loadSnapshot() ?? .preview))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyQuestEntry>) -> Void) {
        let now = Date()
        let snapshot = SharedStore.loadSnapshot()
        var entries = [DailyQuestEntry(date: now, snapshot: snapshot)]
        // Flip to the "open the app" state when the logical day ends.
        if let end = snapshot?.nextDayDate, end > now {
            entries.append(DailyQuestEntry(date: end, snapshot: snapshot))
        }
        // The app reloads timelines whenever its data changes.
        completion(Timeline(entries: entries, policy: .never))
    }
}

// MARK: - Colors

extension Color {
    init(hex: String) {
        var value: UInt64 = 0
        Scanner(string: hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))).scanHexInt64(&value)
        self.init(
            .sRGB,
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255,
            opacity: 1)
    }
}

/// Picks the palette for the app's appearance setting (or the system's).
struct Theme {
    let palette: WidgetPalette
    let isDark: Bool

    init(snapshot: Snapshot?, scheme: ColorScheme) {
        let mode = snapshot?.mode ?? "system"
        isDark = mode == "dark" || (mode == "system" && scheme == .dark)
        palette = snapshot?.colors[isDark ? "dark" : "light"]
            ?? (isDark ? .fallbackDark : .fallbackLight)
    }

    var background: Color { Color(hex: palette.background) }
    var label: Color { Color(hex: palette.label) }
    var secondary: Color { Color(hex: palette.secondary) }
    var fill: Color { Color(hex: palette.fill) }
    var accent: Color { Color(hex: palette.accent) }
    var accentTint: Color { Color(hex: palette.accentTint) }
    var ring: Color { Color(hex: palette.ring) }
    var success: Color { Color(hex: palette.success) }

    func color(_ pair: ColorPair) -> Color { Color(hex: isDark ? pair.dark : pair.light) }
}

// MARK: - Building blocks

struct RingView: View {
    let value: Double
    let theme: Theme
    let lineWidth: CGFloat
    var complete: Bool = false

    var body: some View {
        ZStack {
            Circle().stroke(theme.fill, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: value)
                .stroke(
                    complete ? theme.success : theme.ring,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(Int((value * 100).rounded()))%")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(theme.label)
        }
        .padding(lineWidth / 2)
    }
}

struct TaskGlyph: View {
    let task: WidgetTask
    let theme: Theme
    var size: CGFloat = 22

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.27, style: .continuous)
                .fill(theme.color(task.color))
            if let sf = task.sf {
                Image(systemName: sf).font(.system(size: size * 0.55, weight: .semibold))
            } else {
                Text(task.glyph).font(.system(size: size * 0.55, weight: .semibold))
            }
        }
        .foregroundStyle(theme.color(task.onColor))
        .frame(width: size, height: size)
    }
}

struct ProgressBar: View {
    let value: Double
    let color: Color
    let track: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(track)
                Capsule().fill(color).frame(width: max(0, geo.size.width * value))
            }
        }
        .frame(height: 4)
    }
}

/// The "+" check-in button: interactive on iOS 17, a link into the app before.
struct CheckInButton: View {
    let task: WidgetTask
    let date: String
    let theme: Theme

    var label: some View {
        Image(systemName: "plus")
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(theme.accent)
            .frame(width: 28, height: 28)
            .background(Circle().fill(theme.accentTint))
    }

    var body: some View {
        if #available(iOS 17.0, *) {
            Button(intent: CheckInIntent(taskId: task.id, date: date)) { label }
                .buttonStyle(.plain)
        } else {
            Link(destination: URL(string: "dailyquest://open")!) { label }
        }
    }
}

struct TaskRowView: View {
    let task: WidgetTask
    let date: String
    let theme: Theme
    let showButton: Bool
    let showBar: Bool

    var body: some View {
        HStack(spacing: 8) {
            TaskGlyph(task: task, theme: theme)
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(task.name)
                        .font(.system(size: 14))
                        .strikethrough(task.done)
                        .foregroundStyle(task.done ? theme.secondary : theme.label)
                        .lineLimit(1)
                    Spacer(minLength: 4)
                    Text("\(task.progress)/\(task.target) \(task.unit)")
                        .font(.system(size: 12).monospacedDigit())
                        .foregroundStyle(theme.secondary)
                        .lineLimit(1)
                }
                if showBar {
                    ProgressBar(
                        value: task.fraction,
                        color: task.done ? theme.success : theme.color(task.color),
                        track: theme.fill)
                }
            }
            if task.done {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(theme.success)
                    .frame(width: 28, height: 28)
            } else if showButton {
                CheckInButton(task: task, date: date, theme: theme)
            }
        }
    }
}

// MARK: - Families

struct SmallView: View {
    let entry: DailyQuestEntry
    let theme: Theme

    var body: some View {
        let s = entry.snapshot
        VStack(spacing: 6) {
            RingView(
                value: entry.isStale ? 0 : (s?.ratio ?? 0), theme: theme, lineWidth: 9,
                complete: !entry.isStale && s != nil && s!.total > 0 && s!.done == s!.total)
                .frame(width: 76, height: 76)
            Text(entry.isStale || s == nil ? "–" : "\(s!.done)/\(s!.total)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(theme.label)
            Text(s?.title ?? "")
                .font(.system(size: 12))
                .foregroundStyle(theme.secondary)
        }
    }
}

struct ListLayout: View {
    let entry: DailyQuestEntry
    let theme: Theme
    let maxRows: Int
    let showButton: Bool
    let showBar: Bool

    var body: some View {
        if let s = entry.snapshot, !entry.isStale, !s.tasks.isEmpty {
            VStack(spacing: 6) {
                // Unfinished first so the "+" buttons that matter stay visible.
                ForEach(Array(s.tasks.sorted { !$0.done && $1.done }.prefix(maxRows))) { task in
                    TaskRowView(
                        task: task, date: s.date, theme: theme,
                        showButton: showButton, showBar: showBar)
                }
            }
        } else {
            Text(entry.snapshot == nil ? "" :
                    (entry.isStale ? (entry.snapshot?.staleText ?? "") : entry.snapshot!.emptyText))
                .font(.system(size: 13))
                .foregroundStyle(theme.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct MediumView: View {
    let entry: DailyQuestEntry
    let theme: Theme

    var body: some View {
        HStack(spacing: 12) {
            SmallView(entry: entry, theme: theme).frame(width: 96)
            ListLayout(entry: entry, theme: theme, maxRows: 4, showButton: true, showBar: false)
        }
    }
}

struct LargeView: View {
    let entry: DailyQuestEntry
    let theme: Theme

    var body: some View {
        let s = entry.snapshot
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                RingView(value: entry.isStale ? 0 : (s?.ratio ?? 0), theme: theme, lineWidth: 8)
                    .frame(width: 64, height: 64)
                VStack(alignment: .leading, spacing: 2) {
                    Text(s?.title ?? "").font(.system(size: 13)).foregroundStyle(theme.secondary)
                    Text(entry.isStale || s == nil ? "–" : "\(s!.done)/\(s!.total)")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(theme.label)
                }
                Spacer()
            }
            ListLayout(entry: entry, theme: theme, maxRows: 8, showButton: false, showBar: true)
            Spacer(minLength: 0)
        }
    }
}

/// Lock screen, circular (monochrome): ring gauge with the done count.
struct AccessoryCircularView: View {
    let entry: DailyQuestEntry

    var body: some View {
        let s = entry.snapshot
        Gauge(value: entry.isStale ? 0 : (s?.ratio ?? 0)) {
            EmptyView()
        } currentValueLabel: {
            Text(entry.isStale || s == nil ? "–" : "\(s!.done)/\(s!.total)")
                .font(.system(.body, design: .rounded).weight(.semibold))
        }
        .gaugeStyle(.accessoryCircularCapacity)
    }
}

/// Lock screen, rectangular (monochrome): title, count and a bar.
struct AccessoryRectangularView: View {
    let entry: DailyQuestEntry

    var body: some View {
        let s = entry.snapshot
        VStack(alignment: .leading, spacing: 2) {
            Text(s?.title ?? "").font(.headline).widgetAccentable()
            if let s, !entry.isStale {
                Text("\(s.done)/\(s.total)").font(.system(.body, design: .rounded))
                ProgressView(value: s.ratio)
            } else {
                Text(s?.staleText ?? "").font(.caption).lineLimit(2)
            }
        }
    }
}

struct DailyQuestWidgetView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var colorScheme
    let entry: DailyQuestEntry

    var body: some View {
        let theme = Theme(snapshot: entry.snapshot, scheme: colorScheme)
        content(theme)
            .widgetURL(URL(string: "dailyquest://open"))
            .modifier(WidgetBackground(color: theme.background, family: family))
    }

    @ViewBuilder
    private func content(_ theme: Theme) -> some View {
        switch family {
        case .systemSmall: SmallView(entry: entry, theme: theme)
        case .systemMedium: MediumView(entry: entry, theme: theme)
        case .systemLarge: LargeView(entry: entry, theme: theme)
        case .accessoryCircular: AccessoryCircularView(entry: entry)
        case .accessoryRectangular: AccessoryRectangularView(entry: entry)
        default: SmallView(entry: entry, theme: theme)
        }
    }
}

/// iOS 17 requires `containerBackground`; earlier versions use padding + a
/// plain background. Lock-screen families keep the system (monochrome) look.
struct WidgetBackground: ViewModifier {
    let color: Color
    let family: WidgetFamily

    private var isAccessory: Bool {
        family == .accessoryCircular || family == .accessoryRectangular
    }

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            if isAccessory {
                content.containerBackground(.clear, for: .widget)
            } else {
                content.containerBackground(color, for: .widget)
            }
        } else if isAccessory {
            content
        } else {
            content.padding().background(color)
        }
    }
}

// MARK: - Widget

struct DailyQuestWidget: Widget {
    /// Must match `WidgetKeys.iOSKind` in Dart.
    let kind = "DailyQuestWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyQuestProvider()) { entry in
            DailyQuestWidgetView(entry: entry)
        }
        .configurationDisplayName("每日任务")
        .description("查看今日进度，并在桌面直接打卡。")
        .supportedFamilies([
            .systemSmall, .systemMedium, .systemLarge,
            .accessoryCircular, .accessoryRectangular,
        ])
    }
}

@main
struct DailyQuestWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailyQuestWidget()
    }
}

// MARK: - Preview data

extension Snapshot {
    static let preview = Snapshot(
        v: 1, date: "2026-10-08", done: 1, total: 4, streak: 3, mode: "system",
        title: "今日任务", emptyText: "今天没有安排任务", staleText: "打开 App 开始新的一天",
        nextDayAt: nil,
        colors: ["light": .fallbackLight, "dark": .fallbackDark],
        tasks: [
            WidgetTask(id: 1, templateId: 1, name: "背单词", glyph: "📖", sf: "book.fill",
                       color: ColorPair(light: "#007AFF", dark: "#0A84FF"),
                       onColor: ColorPair(light: "#FFFFFF", dark: "#FFFFFF"),
                       progress: 40, target: 100, step: 10, unit: "个", done: false),
            WidgetTask(id: 2, templateId: 2, name: "数学练习题", glyph: "✏️", sf: "pencil",
                       color: ColorPair(light: "#5856D6", dark: "#5E5CE6"),
                       onColor: ColorPair(light: "#FFFFFF", dark: "#FFFFFF"),
                       progress: 1, target: 1, step: 1, unit: "套", done: true),
            WidgetTask(id: 3, templateId: 3, name: "阅读", glyph: "📝", sf: "doc.text.fill",
                       color: ColorPair(light: "#FF2D55", dark: "#FF375F"),
                       onColor: ColorPair(light: "#FFFFFF", dark: "#FFFFFF"),
                       progress: 10, target: 30, step: 10, unit: "分钟", done: false),
            WidgetTask(id: 4, templateId: 4, name: "运动", glyph: "🔥", sf: "flame.fill",
                       color: ColorPair(light: "#FF3B30", dark: "#FF453A"),
                       onColor: ColorPair(light: "#FFFFFF", dark: "#FFFFFF"),
                       progress: 0, target: 20, step: 10, unit: "分钟", done: false),
        ])
}
