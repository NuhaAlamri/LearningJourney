import Testing
@testable import LearningJourney

@MainActor
struct GoalDraftTests {

    @Test func newDraftIsEmptyWeek() {
        let draft = GoalDraft()
        #expect(draft.topic.isEmpty)
        #expect(draft.duration == .week)
        #expect(!draft.isValid)
    }

    @Test func spacesOnlyIsNotValid() {
        #expect(!GoalDraft(topic: "   ").isValid)
        #expect(!GoalDraft(topic: "\n").isValid)
    }

    @Test func textIsValidAndTrimmed() {
        let draft = GoalDraft(topic: "  Swift  ")
        #expect(draft.isValid)
        #expect(draft.trimmedTopic == "Swift")
    }

    @Test func draftFromGoalCopiesValues() {
        let goal = Goal(topic: "Design", duration: .month)
        let draft = GoalDraft(goal: goal)
        #expect(draft.topic == "Design")
        #expect(draft.duration == .month)
    }
}
