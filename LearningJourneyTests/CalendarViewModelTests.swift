import Testing
import Foundation
@testable import LearningJourney

@MainActor
struct CalendarViewModelTests {

    let calendar = Fixtures.calendar

    func date(_ y: Int, _ m: Int, _ d: Int) -> Date {
        calendar.date(from: DateComponents(year: y, month: m, day: d))!
    }

    @Test func monthsFromFirstGoalToTwelveAhead() {
        let months = CalendarViewModel().months(
            from: date(2024, 10, 20), to: date(2025, 1, 15), calendar: calendar
        )
        #expect(months.count == 4 + 12)                // أكتوبر–يناير + 12 قدام
        #expect(months.first == date(2024, 10, 1))
        #expect(months.last == date(2026, 1, 1))
    }

    @Test func noGoalShowsCurrentMonthAndAhead() {
        let months = CalendarViewModel().months(from: nil, to: date(2024, 10, 24), calendar: calendar)
        #expect(months.count == 1 + 12)
        #expect(months.first == date(2024, 10, 1))     // الحالي أول شي
    }

    @Test func aheadCanBeChanged() {
        let months = CalendarViewModel().months(from: nil, to: date(2024, 10, 24),
                                                ahead: 3, calendar: calendar)
        #expect(months.count == 4)
    }

    @Test func currentMonthIsFirstDayOfMonth() {
        let current = CalendarViewModel().currentMonth(date(2024, 10, 24), calendar: calendar)
        #expect(current == date(2024, 10, 1))
    }

    @Test func dayKindsIncludeAllGoals() {
        let old = Goal(topic: "Swift", duration: .week)
        let new = Goal(topic: "Design", duration: .week)
        let logA = DayLog(kind: .learned, at: Fixtures.october(20), calendar: calendar)
        let logB = DayLog(kind: .freezed, at: Fixtures.october(21), calendar: calendar)
        old.logs.append(logA)
        new.logs.append(logB)

        let kinds = CalendarViewModel().dayKinds(from: [logA, logB])
        #expect(kinds[logA.day] == .learned)
        #expect(kinds[logB.day] == .freezed)
    }
}
