import Foundation
import SwiftData
import Testing
@testable import LearningJourney

@MainActor
struct GoalEndTests {
    let calendar = Fixtures.calendar

    /// تسجيلات Learned من يوم لين يوم، كلها الساعة 10 الصبح
    private func learnedLogs(_ days: [Int]) -> [LogEntry] {
        days.map { day in
            let moment = Fixtures.october(day, hour: 10)
            return LogEntry(day: calendar.startOfDay(for: moment), loggedAt: moment, kind: .learned)
        }
    }

    @Test func lastDayNotLoggedYetStaysActive() {
        let snapshot = StreakEngine.snapshot(
            start: Fixtures.october(18, hour: 9), duration: .week,
            logs: learnedLogs(Array(18...23)),
            now: Fixtures.october(24, hour: 9), calendar: calendar
        )
        #expect(snapshot.goalState == .active)
    }

    @Test func loggingTheLastDayEndsGoalImmediately() {
        let snapshot = StreakEngine.snapshot(
            start: Fixtures.october(18, hour: 9), duration: .week,
            logs: learnedLogs(Array(18...24)),
            now: Fixtures.october(24, hour: 11), calendar: calendar
        )
        #expect(snapshot.goalState == .completed)
    }

    @Test func brokenStreakShowsNotMetOnLastLog() {
        // فجوة من 19 لين 22 = أكثر من 32 ساعة
        let snapshot = StreakEngine.snapshot(
            start: Fixtures.october(18, hour: 9), duration: .week,
            logs: learnedLogs([18, 19, 22, 23, 24]),
            now: Fixtures.october(24, hour: 11), calendar: calendar
        )
        #expect(snapshot.goalState == .notMet)
    }

    @Test func settingNewGoalOnLastDayMarksOldAsCompleted() throws {
        let container = try ModelContainer(
            for: Goal.self, DayLog.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = container.mainContext
        let goal = try context.startGoal(topic: "Swift", duration: .week, now: Fixtures.october(18, hour: 9))
        for day in 18...24 {
            try context.logToday(.learned, for: goal, now: Fixtures.october(day, hour: 10), calendar: calendar)
        }

        let now = Fixtures.october(24, hour: 12)
        try context.replaceGoal(goal, topic: "SwiftUI", duration: .week, now: now, calendar: calendar)

        #expect(goal.endReason == .completed)
        #expect(goal.endedAt == now)
    }
}
