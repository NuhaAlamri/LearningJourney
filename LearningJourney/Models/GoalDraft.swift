import Foundation

/// مسودة الهدف وقت الكتابة، قبل ما ينحفظ
struct GoalDraft: Equatable {
    var topic = ""
    var duration = GoalDuration.week

    /// النص بعد حذف المسافات من البداية والنهاية
    var trimmedTopic: String {
        topic.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// زر Start / Update يشتغل؟
    var isValid: Bool { !trimmedTopic.isEmpty }
}

extension GoalDraft {
    /// مسودة تبدأ من هدف موجود (لشاشة التعديل)
    init(goal: Goal) {
        self.init(topic: goal.topic, duration: goal.duration)
    }
}
