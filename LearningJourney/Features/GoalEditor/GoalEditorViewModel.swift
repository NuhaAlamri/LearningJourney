import Foundation
import SwiftData

/// وضع شاشة الهدف
enum GoalEditorMode {
    case edit   // ✏️: تعديل الهدف الحالي
    case new    // Set a goal: هدف جديد بعد نهاية الحالي
}

/// حالة شاشة Learning Goal وزر ✓
@Observable
final class GoalEditorViewModel {
    let goal: Goal
    let mode: GoalEditorMode
    var draft: GoalDraft
    var isShowingUpdateAlert = false
    var isShowingSaveError = false

    init(goal: Goal, mode: GoalEditorMode) {
        self.goal = goal
        self.mode = mode
        self.draft = mode == .edit ? GoalDraft(goal: goal) : GoalDraft()
    }

    /// غيّر المستخدم شيء عن الهدف الحالي؟
    var hasChanges: Bool {
        mode == .new
            || draft.trimmedTopic != goal.topic
            || draft.duration != goal.duration
    }

    /// زر ✓ شغّال؟
    var canConfirm: Bool { draft.isValid && hasChanges }

    /// يحتاج تنبيه قبل الحفظ؟ (بس في التعديل، لأنه يصفّر السلسلة)
    var needsConfirmation: Bool { mode == .edit }

    /// يقفل الهدف الحالي ويبدأ الجديد
    /// - Returns: `true` إذا انحفظ، عشان الشاشة تقفل بس لما ينجح
    @discardableResult
    func save(in context: ModelContext) -> Bool {
        guard canConfirm else { return false }
        do {
            try context.replaceGoal(goal, topic: draft.trimmedTopic, duration: draft.duration)
            return true
        } catch {
            context.rollback()
            isShowingSaveError = true
            return false
        }
    }
}
