import Testing
import Foundation
import SwiftData
@testable import LearningJourney

@MainActor
struct OnboardingViewModelTests {

    let container: ModelContainer
    var context: ModelContext { container.mainContext }

    init() throws {
        container = try ModelContainer(
            for: Goal.self, DayLog.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    @Test func emptyTopicDoesNotStartGoal() throws {
        let viewModel = OnboardingViewModel()
        viewModel.start(in: context)

        #expect(try context.activeGoal() == nil)
    }

    @Test func validDraftStartsTrimmedGoal() throws {
        let viewModel = OnboardingViewModel()
        viewModel.draft.topic = "  Swift  "
        viewModel.draft.duration = .month
        viewModel.start(in: context)

        let active = try context.activeGoal()
        let goal = try #require(active)
        #expect(goal.topic == "Swift")
        #expect(goal.duration == .month)
    }
}
