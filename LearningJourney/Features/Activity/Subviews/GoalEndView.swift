import SwiftUI

/// نتيجة الهدف بعد ما تنتهي مدته
enum GoalOutcome: Equatable {
    case completed
    case notMet

    var symbol: String {
        switch self {
        case .completed: "hands.and.sparkles.fill"
        case .notMet:    "xmark.seal.fill"
        }
    }

    var title: LocalizedStringKey {
        switch self {
        case .completed: "Well done!"
        case .notMet:    "You didn't reach your goal this time."
        }
    }

    var message: LocalizedStringKey {
        switch self {
        case .completed: "Ready for your next goal?"
        case .notMet:    "Want to set another goal?"
        }
    }
}

/// رسالة نهاية الهدف + زر هدف جديد
struct GoalEndView: View {
    let outcome: GoalOutcome

    @ScaledMetric(relativeTo: .largeTitle) private var iconSize: CGFloat = 40

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: outcome.symbol)
                .font(.system(size: iconSize))
                .foregroundStyle(.learned)
                .accessibilityHidden(true)
                .padding(.bottom, 20)

            Text(outcome.title)
                .font(.callout.bold())

            Text(outcome.message)
                .font(.footnote.weight(.medium))
                .foregroundStyle(.secondary)
                .padding(.bottom, 68)

            NavigationLink(value: Route.newGoal) {
                Label("Set a goal", systemImage: "pencil.and.outline")   // ⚑ الأيقونة
                    .font(.body.weight(.medium))
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .tint(.learned)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }
}

#Preview("Completed") {
    NavigationStack { GoalEndView(outcome: .completed) }
}

#Preview("Not met") {
    NavigationStack { GoalEndView(outcome: .notMet) }
}
