import AppIntents
import WidgetKit

/// "+" button on the medium widget (iOS 17+). Runs in the widget extension
/// process: it only touches the shared queue/snapshot; the app merges the
/// queue into its database (as `source = widget` events) on next launch or
/// when returning to the foreground.
@available(iOS 17.0, *)
struct CheckInIntent: AppIntent {
    static var title: LocalizedStringResource = "Check in"
    static var isDiscoverable: Bool = false

    @Parameter(title: "Task")
    var taskId: Int

    @Parameter(title: "Date")
    var date: String

    init() {}

    init(taskId: Int, date: String) {
        self.taskId = taskId
        self.date = date
    }

    func perform() async throws -> some IntentResult {
        SharedStore.applyCheckIn(taskId: taskId, date: date)
        // WidgetKit reloads the widget's timeline after an intent runs.
        return .result()
    }
}
