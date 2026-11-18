import Foundation
import SwiftData

/// حالة شاشة Onboarding وزر Start
@Observable
final class OnboardingViewModel {
    var draft = GoalDraft()

    /// يظهر تنبيه إذا فشل حفظ الهدف
    var isShowingSaveError = false

    /// Start Learning: يحفظ أول هدف
    func start(in context: ModelContext) {
        guard draft.isValid else { return }
        do {
            try context.startGoal(topic: draft.trimmedTopic, duration: draft.duration)
        } catch {
            context.rollback()
            isShowingSaveError = true
        }
    }
}
