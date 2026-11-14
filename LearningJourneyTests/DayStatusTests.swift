import Testing
@testable import LearningJourney

@MainActor
struct DayStatusTests {

    @Test func learnedAndFreezedIgnoreToday() {
        #expect(DayStatus(kind: .learned, isToday: true) == .learned)
        #expect(DayStatus(kind: .freezed, isToday: false) == .freezed)
    }

    @Test func emptyTodayIsPending() {
        #expect(DayStatus(kind: nil, isToday: true) == .todayPending)
    }

    @Test func emptyOtherDayIsPlain() {
        #expect(DayStatus(kind: nil, isToday: false) == .plain)
    }
}
