import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        VStack(spacing: 16) {
            Text("Hello Learner")
                .font(.largeTitle.bold())
            Button("Start Learning") {
                _ = try? context.startGoal(topic: "Swift", duration: .week)   // مؤقت
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
