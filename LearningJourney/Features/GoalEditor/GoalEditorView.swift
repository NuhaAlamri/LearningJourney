import SwiftUI
import SwiftData

/// شاشة Learning Goal: تعديل الهدف أو هدف جديد
struct GoalEditorView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: GoalEditorViewModel

    init(goal: Goal, mode: GoalEditorMode) {
        self.viewModel = GoalEditorViewModel(goal: goal, mode: mode)
    }

    var body: some View {
        ScrollView {
            GoalFormView(draft: $viewModel.draft)
                .padding(.horizontal, 16)
                .padding(.top, 24)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Learning Goal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    viewModel.save(in: context)
                    dismiss()
                }
                .disabled(!viewModel.canConfirm)
            }
        }
    }
}

#Preview("Edit", traits: .sampleData) {
    @Previewable @Query var goals: [Goal]
    NavigationStack {
        if let goal = goals.first { GoalEditorView(goal: goal, mode: .edit) }
    }
}

#Preview("New", traits: .sampleData) {
    @Previewable @Query var goals: [Goal]
    NavigationStack {
        if let goal = goals.first { GoalEditorView(goal: goal, mode: .new) }
    }
}
