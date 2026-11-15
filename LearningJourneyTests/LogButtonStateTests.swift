import Testing
@testable import LearningJourney

@MainActor
struct LogButtonStateTests {

    @Test func noLogTodayIsReady() {
        #expect(LogButtonState(todayKind: nil) == .ready)
    }

    @Test func learnedTodayShowsLogged() {
        #expect(LogButtonState(todayKind: .learned) == .learnedToday)
    }

    @Test func freezedTodayShowsFreezed() {
        #expect(LogButtonState(todayKind: .freezed) == .freezedToday)
    }
}
