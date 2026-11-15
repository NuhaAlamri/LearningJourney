import Foundation
import SwiftData

/// حالة شاشة Onboarding وزر Start
@Observable
final class OnboardingViewModel {
    var draft = GoalDraft()

    /// Start Learning: يحفظ أول هدف
    func start(in context: ModelContext) {
        guard draft.isValid else { return }
        _ = try? context.startGoal(topic: draft.trimmedTopic, duration: draft.duration)
    }
}
