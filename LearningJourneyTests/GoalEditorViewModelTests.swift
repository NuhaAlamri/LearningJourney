import Testing
import Foundation
import SwiftData
@testable import LearningJourney

@MainActor
struct GoalEditorViewModelTests {

    let container: ModelContainer
    var context: ModelContext { container.mainContext }

    init() throws {
        container = try ModelContainer(
            for: Goal.self, DayLog.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    func makeGoal() throws -> Goal {
        try context.startGoal(topic: "Swift", duration: .week)
    }

    // MARK: - edit

    @Test func editStartsWithCurrentGoal() throws {
        let vm = GoalEditorViewModel(goal: try makeGoal(), mode: .edit)
        #expect(vm.draft.topic == "Swift")
        #expect(vm.draft.duration == .week)
    }

    @Test func editWithoutChangesCannotConfirm() throws {
        let vm = GoalEditorViewModel(goal: try makeGoal(), mode: .edit)
        #expect(!vm.canConfirm)

        vm.draft.topic = "Swift  "          // مسافة بس
        #expect(!vm.canConfirm)
    }

    @Test func editWithChangeCanConfirm() throws {
        let vm = GoalEditorViewModel(goal: try makeGoal(), mode: .edit)
        vm.draft.duration = .month
        #expect(vm.canConfirm)
    }

    @Test func editSaveReplacesGoal() throws {
        let old = try makeGoal()
        let vm = GoalEditorViewModel(goal: old, mode: .edit)
        vm.draft.topic = "Design"
        vm.save(in: context)

        #expect(old.endReason == .replaced)
        #expect(try context.activeGoal()?.topic == "Design")
    }

    // MARK: - new

    @Test func newStartsEmpty() throws {
        let vm = GoalEditorViewModel(goal: try makeGoal(), mode: .new)
        #expect(vm.draft.topic.isEmpty)
        #expect(!vm.canConfirm)

        vm.draft.topic = "Swift"           // نفس الموضوع القديم مسموح
        #expect(vm.canConfirm)
    }
}
