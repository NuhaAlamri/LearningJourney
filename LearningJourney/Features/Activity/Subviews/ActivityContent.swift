import SwiftUI

/// عرض شاشة Activity: ياخذ لقطة ويرسمها، بدون أي قاعدة
struct ActivityContent: View {
    let snapshot: ActivitySnapshot
    var onLog: () -> Void = {}
    var onFreeze: () -> Void = {}

    var body: some View {
        VStack(spacing: 20) {
            Text(snapshot.today, format: .dateTime.weekday(.wide).day().month(.wide))
                .font(.headline)

            HStack(spacing: 12) {
                StatCard.learned(snapshot.streak)
                StatCard.freezed(snapshot.freezesUsed)
            }

            switch snapshot.goalState {
            case .active:
                Button("Log as Learned", action: onLog)
                    .buttonStyle(.borderedProminent)
                    .disabled(!snapshot.canLog)
                Button("Freeze for a day", action: onFreeze)
                    .buttonStyle(.bordered)
                    .disabled(!snapshot.canFreeze)
                Text("\(snapshot.freezesUsed) out of \(snapshot.freezeLimit) Freezes used")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

            case .completed:
                Text("Well done!").font(.callout.bold())
                NavigationLink("Set a goal", value: Route.newGoal)

            case .notMet:
                Text("You didn't reach your goal this time.").font(.callout.bold())
                NavigationLink("Set a goal", value: Route.newGoal)
            }
        }
        .padding()
    }
}

#Preview("Current day") {
    NavigationStack { ActivityContent(snapshot: Fixtures.currentDay.snapshot) }
}

#Preview("Freezed today") {
    NavigationStack { ActivityContent(snapshot: Fixtures.freezedToday.snapshot) }
}

#Preview("No Freezes available") {
    NavigationStack { ActivityContent(snapshot: Fixtures.noFreezesLeft.snapshot) }
}

#Preview("Goal not met") {
    NavigationStack { ActivityContent(snapshot: Fixtures.goalNotMet.snapshot) }
}
