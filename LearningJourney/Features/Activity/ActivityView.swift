import SwiftUI
import SwiftData

/// الحاوية: تربط الهدف والوقت بالمحرك، وتمرر اللقطة للعرض
struct ActivityView: View {
    let goal: Goal

    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel = ActivityViewModel()
    @State private var isEditingGoal = false

    var body: some View {
        TimelineView(.everyMinute) { timeline in
            ActivityContent(
                snapshot: viewModel.snapshot(for: goal, now: timeline.date, context: context),
                onLog: {
                    withAnimation(logAnimation) {
                        viewModel.log(.learned, for: goal, context: context)
                    }
                },
                onFreeze: {
                    withAnimation(logAnimation) {
                        viewModel.log(.freezed, for: goal, context: context)
                    }
                }
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: Route.calendar) {
                    Label("Calendar", systemImage: "calendar")
                }
            }

            ToolbarSpacer(.fixed, placement: .topBarTrailing)

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isEditingGoal = true
                } label: {
                    Label("Learning Goal", systemImage: "pencil.and.outline")
                }
            }
        }
        .sheet(isPresented: $isEditingGoal) {
            NavigationStack {
                GoalEditorView(goal: goal, mode: .edit)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(role: .close) {
                                isEditingGoal = false
                            }
                        }
                    }
            }
        }
        .alert("Couldn't Save", isPresented: $viewModel.isShowingSaveError) {
        } message: {
            Text("Your day wasn't logged. Please try again.")
        }
    }

    /// حركة التسجيل: هادية لو المستخدم فعّل Reduce Motion
    private var logAnimation: Animation {
        reduceMotion ? .easeInOut(duration: 0.2) : .snappy
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query var goals: [Goal]
    NavigationStack {
        if let goal = goals.first { ActivityView(goal: goal) }
    }
}
