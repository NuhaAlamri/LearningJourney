import Foundation
import SwiftData

extension ModelContext {

    /// الهدف الحالي: اللي ما انتهى
    func activeGoal() throws -> Goal? {
        var descriptor = FetchDescriptor<Goal>(
            predicate: #Predicate { $0.endedAt == nil },
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return try fetch(descriptor).first
    }

    /// هل فيه تسجيل في هذا اليوم، في أي هدف؟
    func hasLog(on day: Date) throws -> Bool {
        let descriptor = FetchDescriptor<DayLog>(predicate: #Predicate { $0.day == day })
        return try fetchCount(descriptor) > 0
    }

    /// يبدأ هدف جديد (Start Learning)
    @discardableResult
    func startGoal(topic: String, duration: GoalDuration, now: Date = .now) throws -> Goal {
        let cleanTopic = topic.trimmingCharacters(in: .whitespacesAndNewlines)
        let goal = Goal(topic: cleanTopic, duration: duration, startDate: now)
        insert(goal)
        try save()
        return goal
    }

    /// يسجّل اليوم Learned أو Freezed، إذا سمحت القواعد
    /// - Returns: `true` إذا انحفظ التسجيل
    @discardableResult
    func logToday(
        _ kind: DayLog.Kind,
        for goal: Goal,
        now: Date = .now,
        calendar: Calendar = .current
    ) throws -> Bool {
        let snapshot = StreakEngine.snapshot(
            start: goal.startDate,
            duration: goal.duration,
            logs: goal.logs.map(\.entry),
            now: now,
            calendar: calendar
        )
        let allowed = kind == .learned ? snapshot.canLog : snapshot.canFreeze
        guard allowed else { return false }
        guard try !hasLog(on: calendar.startOfDay(for: now)) else { return false }

        goal.logs.append(DayLog(kind: kind, at: now, calendar: calendar))
        try save()
        return true
    }

    /// يغلق الهدف الحالي ويبدأ واحد جديد (Update أو Set a goal)
    @discardableResult
    func replaceGoal(
        _ old: Goal,
        topic: String,
        duration: GoalDuration,
        now: Date = .now,
        calendar: Calendar = .current
    ) throws -> Goal {
        let end = old.duration.endDate(from: old.startDate, calendar: calendar)
        if now >= end {
            old.endedAt = end              // انتهى بالوقت
            old.endReason = .completed
        } else {
            old.endedAt = now              // المستخدم غيّره قبل النهاية
            old.endReason = .replaced
        }
        return try startGoal(topic: topic, duration: duration, now: now)
    }
}
