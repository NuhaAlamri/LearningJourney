import SwiftUI
import SwiftData

struct RootView: View {
    @Query(sort: \Goal.startDate, order: .reverse) private var goals: [Goal]

    var body: some View {
        Group {
            if let goal = goals.first {
                NavigationStack {
                    ActivityView(goal: goal)
                        .navigationDestination(for: Route.self) { route in
                            destination(for: route, goal: goal)
                        }
                }
            } else {
                OnboardingView()
            }
        }
        .animation(.default, value: goals.isEmpty)
    }

    @ViewBuilder
    private func destination(for route: Route, goal: Goal) -> some View {
        switch route {
        case .calendar: CalendarView()
        case .editGoal: GoalEditorView(goal: goal, isNewGoal: false)
        case .newGoal:  GoalEditorView(goal: goal, isNewGoal: true)
        }
    }
}

#Preview("No goal") {
    RootView()
        .modelContainer(for: [Goal.self, DayLog.self], inMemory: true)
}

#Preview("With goal", traits: .sampleData) {
    RootView()
}
