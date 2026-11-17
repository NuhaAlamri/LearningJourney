import Foundation
import Testing
@testable import LearningJourney

/// اختبارات القرارات النهائية اللي ما كان لها اختبار (T39)
@MainActor
struct BusinessRulesTests {
    let calendar = Fixtures.calendar

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day))!
    }

    // MARK: - طول الشهر والسنة

    @Test func monthGoalEndsOnSameDayNextMonth() {
        let end = GoalDuration.month.endDate(from: Fixtures.october(18, hour: 9), calendar: calendar)
        #expect(end == date(2024, 11, 18))
    }

    @Test func monthGoalFromJan31EndsOnLastDayOfFebruary() {
        let start = date(2024, 1, 31)
        let end = GoalDuration.month.endDate(from: start, calendar: calendar)
        #expect(end == date(2024, 2, 29))   // 2024 سنة كبيسة
    }

    @Test func yearGoalEndsOnSameDayNextYear() {
        let end = GoalDuration.year.endDate(from: Fixtures.october(18, hour: 9), calendar: calendar)
        #expect(end == date(2025, 10, 18))
    }

    // MARK: - نطاق رصيد الـ Freeze

    @Test func freezesStayUsedAfterStreakBreaks() {
        func entry(_ day: Int, _ kind: DayLog.Kind) -> LogEntry {
            let moment = Fixtures.october(day, hour: 10)
            return LogEntry(day: calendar.startOfDay(for: moment), loggedAt: moment, kind: kind)
        }
        // فريز 20، تعلم 21، ثم فجوة (انكسر)، ثم فريز 24
        let snapshot = StreakEngine.snapshot(
            start: Fixtures.october(20, hour: 9), duration: .week,
            logs: [entry(20, .freezed), entry(21, .learned), entry(24, .freezed)],
            now: Fixtures.october(25, hour: 9), calendar: calendar
        )

        #expect(snapshot.streak == 1)          // السلسلة الجديدة: يوم 24 بس
        #expect(snapshot.freezesUsed == 2)     // الرصيد محسوب على الهدف كامل
        #expect(snapshot.canFreeze == false)   // Week = 2، خلص
        #expect(snapshot.canLog == true)       // التعلم لسا مسموح
    }
}
