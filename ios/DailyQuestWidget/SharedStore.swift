import Foundation

/// Mirror of the Dart `WidgetSnapshot` JSON (see
/// lib/widgets_bridge/widget_snapshot.dart). Bump `supportedVersion` together
/// with `WidgetSnapshot.version`.
struct ColorPair: Codable, Hashable {
    let light: String
    let dark: String
}

struct WidgetPalette: Codable, Hashable {
    let background: String
    let label: String
    let secondary: String
    let fill: String
    let accent: String
    let accentTint: String
    let onAccent: String
    let ring: String
    let success: String

    static let fallbackLight = WidgetPalette(
        background: "#FFFFFF", label: "#1C1C1E", secondary: "#6E6E73", fill: "#E5E5EA",
        accent: "#0062CC", accentTint: "#E0EDFA", onAccent: "#FFFFFF", ring: "#007AFF",
        success: "#248A3D")
    static let fallbackDark = WidgetPalette(
        background: "#1C1C1E", label: "#FFFFFF", secondary: "#98989D", fill: "#3A3A3C",
        accent: "#5AA9FF", accentTint: "#27374A", onAccent: "#000000", ring: "#0A84FF",
        success: "#30D158")
}

struct WidgetTask: Codable, Hashable, Identifiable {
    let id: Int
    let templateId: Int
    let name: String
    let glyph: String
    let sf: String?
    let color: ColorPair
    let onColor: ColorPair
    var progress: Int
    let target: Int
    let step: Int
    let unit: String
    var done: Bool

    var fraction: Double { target <= 0 ? 0 : min(1, Double(progress) / Double(target)) }
}

struct Snapshot: Codable, Hashable {
    static let supportedVersion = 1

    let v: Int
    let date: String
    var done: Int
    let total: Int
    let streak: Int
    let mode: String
    let title: String
    let emptyText: String
    let staleText: String?
    let nextDayAt: String?
    let colors: [String: WidgetPalette]
    var tasks: [WidgetTask]

    var ratio: Double { total == 0 ? 0 : Double(done) / Double(total) }

    /// Local wall-clock time at which this snapshot's logical day ends.
    var nextDayDate: Date? {
        guard let nextDayAt else { return nil }
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return f.date(from: nextDayAt)
    }

    func isStale(at date: Date) -> Bool {
        guard let end = nextDayDate else { return false }
        return date >= end
    }
}

/// One queued widget check-in; mirrors Dart `PendingWidgetEvent`.
struct PendingEvent: Codable {
    let id: String
    let dailyTaskId: Int
    let date: String
    let occurredAt: String
    let action: String
}

/// Access to the App Group storage shared with the Flutter app (written via
/// `home_widget`, which stores strings in `UserDefaults(suiteName:)`).
enum SharedStore {
    static let appGroup = "group.com.example.dailyquest"
    static let snapshotKey = "dq_snapshot"
    static let pendingKey = "dq_pending"

    static var defaults: UserDefaults? { UserDefaults(suiteName: appGroup) }

    static func loadSnapshot() -> Snapshot? {
        guard let raw = defaults?.string(forKey: snapshotKey),
              let data = raw.data(using: .utf8),
              let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data),
              snapshot.v == Snapshot.supportedVersion
        else { return nil }
        return snapshot
    }

    /// Mirrors Dart `WidgetTap.apply`: queue an "advance" event for the app
    /// to merge later and optimistically bump the task in the snapshot.
    /// Returns `false` when the tap is ignored.
    @discardableResult
    static func applyCheckIn(taskId: Int, date: String, now: Date = Date()) -> Bool {
        guard let defaults, var snapshot = loadSnapshot(), snapshot.date == date,
              let index = snapshot.tasks.firstIndex(where: { $0.id == taskId }),
              !snapshot.tasks[index].done, !snapshot.isStale(at: now)
        else { return false }

        var task = snapshot.tasks[index]
        task.progress = min(task.target, task.progress + task.step)
        if task.progress >= task.target {
            task.done = true
            snapshot.done += 1
        }
        snapshot.tasks[index] = task

        var queue: [PendingEvent] = []
        if let raw = defaults.string(forKey: pendingKey), let data = raw.data(using: .utf8) {
            queue = (try? JSONDecoder().decode([PendingEvent].self, from: data)) ?? []
        }
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        queue.append(PendingEvent(
            id: UUID().uuidString,
            dailyTaskId: taskId,
            date: date,
            occurredAt: iso.string(from: now),
            action: "advance"))

        let encoder = JSONEncoder()
        if let q = try? encoder.encode(queue), let s = try? encoder.encode(snapshot) {
            defaults.set(String(decoding: q, as: UTF8.self), forKey: pendingKey)
            defaults.set(String(decoding: s, as: UTF8.self), forKey: snapshotKey)
        }
        return true
    }
}
