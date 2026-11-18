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
                .padding(.top, 36)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Learning Goal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    if viewModel.needsConfirmation {
                        viewModel.isShowingUpdateAlert = true
                    } else {
                        commit()
                    }
                }
                .disabled(!viewModel.canConfirm)
            }
        }
        .alert("Update Goal", isPresented: $viewModel.isShowingUpdateAlert) {
            Button(role: .cancel) { }
            Button("Update", role: .confirm) { commit() }
                .keyboardShortcut(.defaultAction)
        } message: {
            Text("If you update now, your streak will start over.")
        }
        .alert("Couldn't Save", isPresented: $viewModel.isShowingSaveError) {
        } message: {
            Text("Your goal wasn't updated. Please try again.")
        }
    }

    /// يحفظ ويرجع لـ Activity (بس لو الحفظ نجح)
    private func commit() {
        if viewModel.save(in: context) {
            dismiss()
        }
    }
}

#Preview("Update Learning goal", traits: .sampleData) {
    @Previewable @Query var goals: [Goal]
    NavigationStack {
        if let goal = goals.first {
            GoalEditorView(goal: goal, mode: .edit)
        }
    }
}

#Preview("Set a Goal", traits: .endedGoal) {
    @Previewable @Query var goals: [Goal]
    NavigationStack {
        if let goal = goals.first {
            GoalEditorView(goal: goal, mode: .new)
        }
    }
}
