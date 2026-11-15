import SwiftUI
import SwiftData

/// يجهّز قاعدة بيانات مؤقتة للمعاينات
struct SampleData: PreviewModifier {

    static func makeSharedContext() throws -> ModelContainer {
        try container(with: Fixtures.currentDay)
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }

    /// قاعدة بيانات في الذاكرة فيها حالة وحدة من Fixtures
    static func container(with state: Fixtures.State) throws -> ModelContainer {
        let container = try ModelContainer(
            for: Goal.self, DayLog.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        state.insert(into: container.mainContext)
        return container
    }
}

/// بيانات هدف انتهت مدته (لتجربة Well done + Set a goal)
struct EndedGoalData: PreviewModifier {

    static func makeSharedContext() throws -> ModelContainer {
        try SampleData.container(with: Fixtures.goalCompleted)
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
    @MainActor static var endedGoal: Self = .modifier(EndedGoalData())
}

#Preview("Sample data", traits: .sampleData) {
    @Previewable @Query(sort: \DayLog.day) var logs: [DayLog]

    List(logs) { log in
        HStack {
            Text(log.day, format: .dateTime.weekday(.wide).day().month())
            Spacer()
            Text(log.kind == .learned ? "Learned" : "Freezed")
                .foregroundStyle(log.kind == .learned ? Color.learned : Color.freeze)
        }
    }
}
