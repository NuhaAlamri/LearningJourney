import Testing
import Foundation
@testable import LearningJourney

@MainActor
struct CalendarViewModelTests {

    let calendar = Fixtures.calendar

    @Test func monthsFromFirstGoalToNow() {
        let vm = CalendarViewModel()
        let months = vm.months(from: Fixtures.october(20),
                               to: calendar.date(from: DateComponents(year: 2025, month: 1, day: 15))!,
                               calendar: calendar)
        #expect(months.count == 4)   // أكتوبر، نوفمبر، ديسمبر، يناير
    }

    @Test func noGoalShowsCurrentMonthOnly() {
        let vm = CalendarViewModel()
        #expect(vm.months(from: nil, to: Fixtures.october(24), calendar: calendar).count == 1)
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
