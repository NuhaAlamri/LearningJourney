import SwiftUI
import SwiftData

/// الحاوية: تربط الهدف والوقت بالمحرك، وتمرر اللقطة للعرض
struct ActivityView: View {
    let goal: Goal

    @Environment(\.modelContext) private var context
    @State private var viewModel = ActivityViewModel()

    var body: some View {
        TimelineView(.everyMinute) { timeline in
            ActivityContent(
                snapshot: viewModel.snapshot(for: goal, now: timeline.date, context: context),
                onLog: { viewModel.log(.learned, for: goal, context: context) },
                onFreeze: { viewModel.log(.freezed, for: goal, context: context) }
            )
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink(value: Route.editGoal) {
                    Label("Learning Goal", systemImage: "pencil.and.outline")
                }
                NavigationLink(value: Route.calendar) {
                    Label("Calendar", systemImage: "calendar")
                    
                }
            }
        }
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query var goals: [Goal]
    NavigationStack {
        if let goal = goals.first { ActivityView(goal: goal) }
    }
}
