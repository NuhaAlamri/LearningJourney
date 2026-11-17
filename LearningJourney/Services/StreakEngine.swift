import Foundation

/// نسخة بسيطة من DayLog، بدون SwiftData
struct LogEntry: Equatable {
    let day: Date
    let loggedAt: Date
    let kind: DayLog.Kind
}

extension DayLog {
    var entry: LogEntry { LogEntry(day: day, loggedAt: loggedAt, kind: kind) }
}

/// كل قواعد السلسلة في مكان واحد
enum StreakEngine {
    
    /// أقصى فرق مسموح بين تسجيلين: 32 ساعة بالثواني
    static let maxGap: TimeInterval = 32 * 60 * 60
    
    static func snapshot(
        start: Date,
        duration: GoalDuration,
        logs: [LogEntry],
        otherLogs: [LogEntry] = [],
        now: Date,
        calendar: Calendar = .current
    ) -> ActivitySnapshot {
        let today = calendar.startOfDay(for: now)
        let todayKind = logs.first { $0.day == today }?.kind
        let end = duration.endDate(from: start, calendar: calendar)
        let finished = isFinished(end: end, todayKind: todayKind, now: now, calendar: calendar)
        let goalState: ActivitySnapshot.GoalState =
            finished ? goalResult(logs: logs, end: end) : .active
        let chain = currentChain(logs, at: min(now, end))
        let loggedTodayElsewhere = otherLogs.contains { $0.day == today }

        return ActivitySnapshot(
            today: today,
            streak: chain.count,
            learnedDays: chain.filter { $0.kind == .learned }.count,
            freezesUsed: logs.filter { $0.kind == .freezed }.count,
            freezeLimit: duration.freezeLimit,
            todayKind: todayKind,
            goalState: goalState,
            dayKinds: Dictionary((otherLogs + logs).map { ($0.day, $0.kind) },
                                 uniquingKeysWith: { _, latest in latest }),
            todayLoggedInOtherGoal: loggedTodayElsewhere && todayKind == nil
        )
    }
    
    static func isFinished(
        end: Date,
        todayKind: DayLog.Kind?,
        now: Date,
        calendar: Calendar = .current
    ) -> Bool {
        guard now < end else { return true }
        guard todayKind != nil,
              let lastDay = calendar.date(byAdding: .day, value: -1, to: end) else { return false }
        return calendar.startOfDay(for: now) == lastDay
    }
    
    /// السجلات من آخر انقطاع لين اللحظة المعطاة
    static func currentChain(_ logs: [LogEntry], at moment: Date) -> [LogEntry] {
        let sorted = logs.sorted { $0.loggedAt < $1.loggedAt }
        guard let last = sorted.last,
              moment.timeIntervalSince(last.loggedAt) <= maxGap else { return [] }
        
        var chain = [last]
        for log in sorted.dropLast().reversed() {
            guard chain[0].loggedAt.timeIntervalSince(log.loggedAt) <= maxGap else { break }
            chain.insert(log, at: 0)
        }
        return chain
    }
    
    static func goalResult(logs: [LogEntry], end: Date) -> ActivitySnapshot.GoalState {
        guard !logs.isEmpty else { return .notMet }
        
        let moments = logs.map(\.loggedAt).sorted() + [end]
        for (earlier, later) in zip(moments, moments.dropFirst())
                where later.timeIntervalSince(earlier) > maxGap {
            return .notMet
        }
        return .completed
    }
}
