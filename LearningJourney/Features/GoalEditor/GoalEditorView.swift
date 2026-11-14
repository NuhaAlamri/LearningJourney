import SwiftUI
import SwiftData

struct GoalEditorView: View {
    let goal: Goal
    let isNewGoal: Bool

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button("Save (temporary)") {
            _ = try? context.replaceGoal(goal, topic: "Design", duration: .month)
            dismiss()
        }
        .navigationTitle("Learning Goal")
    }
}
