import Testing
import Foundation
import SwiftData
@testable import LearningJourney

@MainActor
struct ActivityViewModelTests {

    let container: ModelContainer
    var context: ModelContext { container.mainContext }

    init() throws {
        container = try ModelContainer(
            for: Goal.self, DayLog.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    @Test func successfulLogShowsNoError() throws {
        let goal = try context.startGoal(topic: "Swift", duration: .week)
        let viewModel = ActivityViewModel()

        viewModel.log(.learned, for: goal, context: context)

        #expect(goal.logs.count == 1)
        #expect(!viewModel.isShowingSaveError)
    }

    @Test func secondLogIsBlockedWithoutError() throws {
        let goal = try context.startGoal(topic: "Swift", duration: .week)
        let viewModel = ActivityViewModel()

        viewModel.log(.learned, for: goal, context: context)
        viewModel.log(.learned, for: goal, context: context)

        #expect(goal.logs.count == 1)            // القاعدة منعت الثاني
        #expect(!viewModel.isShowingSaveError)   // وهذا مو خطأ حفظ
    }
}
