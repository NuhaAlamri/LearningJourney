import Foundation
import SwiftData

/// يربط شاشة Activity بالمحرك والأفعال
@Observable
final class ActivityViewModel {

    /// لقطة الشاشة في لحظة معيّنة
    func snapshot(for goal: Goal, now: Date, context: ModelContext,
                  calendar: Calendar = .current) -> ActivitySnapshot {
        let today = calendar.startOfDay(for: now)
        let loggedToday = (try? context.hasLog(on: today)) ?? false

        return StreakEngine.snapshot(
            start: goal.startDate,
            duration: goal.duration,
            logs: goal.logs.map(\.entry),
            now: now,
            loggedTodayInAnyGoal: loggedToday,
            calendar: calendar
        )
    }

    /// المستخدم ضغط Log أو Freeze
    func log(_ kind: DayLog.Kind, for goal: Goal, context: ModelContext) {
        _ = try? context.logToday(kind, for: goal, now: .now)
    }
}
