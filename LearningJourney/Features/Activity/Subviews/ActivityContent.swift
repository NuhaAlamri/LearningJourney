import SwiftUI

/// عرض شاشة Activity: ياخذ لقطة ويرسمها، بدون أي قاعدة
struct ActivityContent: View {
    let snapshot: ActivitySnapshot
    var onLog: () -> Void = {}
    var onFreeze: () -> Void = {}
    var calendar: Calendar = .current

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text(snapshot.today, format: .dateTime.weekday(.wide).day().month(.wide))
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 2)

                VStack(spacing: 12) {
                    WeekStripView(
                        days: CalendarMath.weekDays(containing: snapshot.today, calendar: calendar),
                        symbols: CalendarMath.weekdaySymbols(calendar: calendar),
                        status: dayStatus(for:),
                        calendar: calendar
                    )

                    HStack(spacing: 12) {
                        StatCard.learned(snapshot.learnedDays)
                        StatCard.freezed(snapshot.freezesUsed)
                    }
                }
                .padding(.top, 15)

                switch snapshot.goalState {
                case .active:
                    LogButton(
                        state: LogButtonState(todayKind: snapshot.kind(on: snapshot.today)),
                        isEnabled: snapshot.canLog,
                        action: onLog
                    )
                    .padding(.top, 48)

                    FreezeSection(
                        canFreeze: snapshot.canFreeze,
                        isFreezedToday: snapshot.kind(on: snapshot.today) == .freezed,
                        used: snapshot.freezesUsed,
                        limit: snapshot.freezeLimit,
                        action: onFreeze
                    )
                    .padding(.top, 48)

                case .completed:
                    GoalEndView(outcome: .completed)
                        .padding(.top, 69)

                case .notMet:
                    GoalEndView(outcome: .notMet)
                        .padding(.top, 69)
                }
            }
            .padding(.horizontal, 13)
            .padding(.bottom, 24)
            .animation(.default, value: snapshot.goalState)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Activity")
                    .font(.largeTitle.bold())
                    .fixedSize()
                    .accessibilityAddTraits(.isHeader)
            }
            .sharedBackgroundVisibility(.hidden)
        }
    }

    /// حالة كل يوم في الشريط
    private func dayStatus(for day: Date) -> DayStatus {
        // "اليوم بانتظار تسجيل" بس إذا المستخدم يقدر يسجّل فعلاً
        let isPendingToday = day == snapshot.today && snapshot.canLog
        return DayStatus(kind: snapshot.kind(on: day), isToday: isPendingToday)
    }
}

#Preview("Current day - Default") {
    NavigationStack {
        ActivityContent(snapshot: Fixtures.currentDay.snapshot, calendar: Fixtures.calendar)
    }
}

#Preview("Learned today") {
    NavigationStack {
        ActivityContent(snapshot: Fixtures.learnedToday.snapshot, calendar: Fixtures.calendar)
    }
}

#Preview("Freezed today") {
    NavigationStack {
        ActivityContent(snapshot: Fixtures.freezedToday.snapshot, calendar: Fixtures.calendar)
    }
}

#Preview("No Freezes available") {
    NavigationStack {
        ActivityContent(snapshot: Fixtures.noFreezesLeft.snapshot, calendar: Fixtures.calendar)
    }
}

#Preview("Activity - Goal Completed") {
    NavigationStack {
        ActivityContent(snapshot: Fixtures.goalCompleted.snapshot, calendar: Fixtures.calendar)
    }
}

#Preview("Activity - Goal not met") {
    NavigationStack {
        ActivityContent(snapshot: Fixtures.goalNotMet.snapshot, calendar: Fixtures.calendar)
    }
}
