import Foundation
import SwiftData

/// يربط شاشة Activity بالمحرك والأفعال
@Observable
final class ActivityViewModel {

    /// لقطة الشاشة في لحظة معيّنة
    func snapshot(for goal: Goal, now: Date, context: ModelContext,
                  calendar: Calendar = .current) -> ActivitySnapshot {
        StreakEngine.snapshot(
            start: goal.startDate,
            duration: goal.duration,
            logs: goal.logs.map(\.entry),
            otherLogs: otherLogs(for: goal, around: now, context: context, calendar: calendar),
            now: now,
            calendar: calendar
        )
    }

    /// المستخدم ضغط Log أو Freeze
    func log(_ kind: DayLog.Kind, for goal: Goal, context: ModelContext) {
        _ = try? context.logToday(kind, for: goal, now: .now)
    }

    /// تسجيلات الأهداف السابقة في الأسبوع الظاهر (للألوان بس)
    private func otherLogs(for goal: Goal, around now: Date, context: ModelContext,
                           calendar: Calendar) -> [LogEntry] {
        let week = CalendarMath.weekDays(containing: now, calendar: calendar)
        guard let first = week.first, let last = week.last else { return [] }

        let descriptor = FetchDescriptor<DayLog>(
            predicate: #Predicate { $0.day >= first && $0.day <= last }
        )
        let logs = (try? context.fetch(descriptor)) ?? []
        return logs.filter { $0.goal !== goal }.map(\.entry)
    }
}
