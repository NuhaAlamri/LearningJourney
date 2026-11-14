import SwiftUI

struct ActivityView: View {
    let goal: Goal

    var body: some View {
        VStack(spacing: 16) {
            Text(goal.topic)
                .font(.title)
            NavigationLink("Set a goal", value: Route.newGoal)   // مؤقت للتجربة
        }
        .navigationTitle("Activity")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: Route.calendar) {
                    Label("Calendar", systemImage: "calendar")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: Route.editGoal) {
                    Label("Learning Goal", systemImage: "pencil.and.outline")
                }
            }
        }
    }
}
