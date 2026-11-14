import Testing
import Foundation
import SwiftData
@testable import LearningJourney

@MainActor
struct GoalActionsTests {

    let container: ModelContainer
    var context: ModelContext { container.mainContext }
    let calendar = Fixtures.calendar

    init() throws {
        container = try ModelContainer(
            for: Goal.self, DayLog.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    func at(_ day: Int, _ hour: Int = 9) -> Date {
        Fixtures.october(day, hour: hour)
    }

    // MARK: - startGoal

    @Test func startGoalSavesAnActiveGoal() throws {
        try context.startGoal(topic: "  Swift  ", duration: .week, now: at(20))

        let active = try context.activeGoal()
        let goal = try #require(active)
        #expect(goal.topic == "Swift")
        #expect(goal.duration == .week)
        #expect(goal.isActive)
    }

    @Test func noGoalBeforeOnboarding() throws {
        #expect(try context.activeGoal() == nil)
    }

    // MARK: - logToday

    @Test func logTodaySavesOneLog() throws {
        let goal = try context.startGoal(topic: "Swift", duration: .week, now: at(20))
        let saved = try context.logToday(.learned, for: goal, now: at(20, 10), calendar: calendar)

        #expect(saved)
        #expect(goal.logs.count == 1)
    }

    @Test func secondLogOnSameDayIsRejected() throws {
        let goal = try context.startGoal(topic: "Swift", duration: .week, now: at(20))
        try context.logToday(.learned, for: goal, now: at(20, 10), calendar: calendar)
        let second = try context.logToday(.freezed, for: goal, now: at(20, 22), calendar: calendar)

        #expect(!second)
        #expect(goal.logs.count == 1)
        #expect(goal.logs.first?.kind == .learned)
    }

    @Test func freezeRejectedWhenLimitReachedButLearnedAllowed() throws {
        let goal = try context.startGoal(topic: "Swift", duration: .week, now: at(20))
        try context.logToday(.freezed, for: goal, now: at(20), calendar: calendar)
        try context.logToday(.freezed, for: goal, now: at(21), calendar: calendar)

        #expect(try !context.logToday(.freezed, for: goal, now: at(22), calendar: calendar))
        #expect(try context.logToday(.learned, for: goal, now: at(22), calendar: calendar))
    }

    // MARK: - replaceGoal

    @Test func updateMidWayKeepsHistoryAndResetsStreak() throws {
        let old = try context.startGoal(topic: "Swift", duration: .week, now: at(20))
        try context.logToday(.learned, for: old, now: at(20), calendar: calendar)

        let new = try context.replaceGoal(old, topic: "Design", duration: .month,
                                          now: at(22), calendar: calendar)

        #expect(old.endedAt == at(22))
        #expect(old.endReason == .replaced)
        #expect(old.logs.count == 1)          // السجل باقي للتقويم
        #expect(new.logs.isEmpty)             // السلسلة تبدأ من الصفر
        #expect(try context.activeGoal() === new)
    }

    @Test func setGoalAfterEndMarksOldAsCompleted() throws {
        let old = try context.startGoal(topic: "Swift", duration: .week, now: at(20))
        try context.replaceGoal(old, topic: "Design", duration: .week, now: at(28), calendar: calendar)

        #expect(old.endReason == .completed)
        #expect(old.endedAt == GoalDuration.week.endDate(from: at(20), calendar: calendar))
    }

    @Test func cannotLogTwiceOnSameDayAcrossGoals() throws {
        let old = try context.startGoal(topic: "Swift", duration: .week, now: at(20))
        try context.logToday(.learned, for: old, now: at(20, 10), calendar: calendar)
        let new = try context.replaceGoal(old, topic: "Design", duration: .week,
                                          now: at(20, 15), calendar: calendar)

        #expect(try !context.logToday(.learned, for: new, now: at(20, 16), calendar: calendar))
        #expect(old.logs.count == 1)   // تسجيل الهدف القديم ما انمسح
    }
    // MARK: - Extra (T11)

    @Test func savedDataIsVisibleFromANewContext() throws {
        let goal = try context.startGoal(topic: "Swift", duration: .week, now: at(20))
        try context.logToday(.learned, for: goal, now: at(20, 10), calendar: calendar)

        let fresh = ModelContext(container)
        let logs = try fresh.fetch(FetchDescriptor<DayLog>())
        #expect(logs.count == 1)
        #expect(logs.first?.goal?.topic == "Swift")
    }

    @Test func cannotLogAfterGoalEnded() throws {
        let goal = try context.startGoal(topic: "Swift", duration: .week, now: at(20))

        #expect(try !context.logToday(.learned, for: goal, now: at(27, 10), calendar: calendar))
        #expect(goal.logs.isEmpty)
    }

    @Test func canLogAgainRightAfterMidnight() throws {
        let goal = try context.startGoal(topic: "Swift", duration: .week, now: at(20))

        #expect(try context.logToday(.learned, for: goal, now: at(20, 23), calendar: calendar))
        #expect(try context.logToday(.learned, for: goal, now: at(21, 0), calendar: calendar))
        #expect(goal.logs.count == 2)
    }
}
