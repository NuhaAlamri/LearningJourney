import SwiftUI

/// عرض شاشة Activity: ياخذ لقطة ويرسمها، بدون أي قاعدة
struct ActivityContent: View {
    let snapshot: ActivitySnapshot
    var onLog: () -> Void = {}
    var onFreeze: () -> Void = {}
    var calendar: Calendar = .current

    var body: some View {
        VStack(spacing: 20) {
            Text(snapshot.today, format: .dateTime.weekday(.wide).day().month(.wide))
                .font(.headline)

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

            switch snapshot.goalState {
            case .active:
                LogButton(
                    state: LogButtonState(todayKind: snapshot.todayKind),
                    isEnabled: snapshot.canLog,
                    action: onLog
                )
                FreezeSection(
                    canFreeze: snapshot.canFreeze,
                    isFreezedToday: snapshot.todayKind == .freezed,
                    used: snapshot.freezesUsed,
                    limit: snapshot.freezeLimit,
                    action: onFreeze
                )

            case .completed:
                GoalEndView(outcome: .completed)

            case .notMet:
                GoalEndView(outcome: .notMet)
            }
        }
        .padding()
    }

    /// حالة كل يوم في الشريط
    private func dayStatus(for day: Date) -> DayStatus {
        // "اليوم بانتظار تسجيل" بس إذا المستخدم يقدر يسجّل فعلاً
        let isPendingToday = day == snapshot.today && snapshot.canLog
        return DayStatus(kind: snapshot.kind(on: day), isToday: isPendingToday)
    }
}

#Preview("Current day") {
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

#Preview("Goal completed") {
    NavigationStack {
        ActivityContent(snapshot: Fixtures.goalCompleted.snapshot, calendar: Fixtures.calendar)
    }
}

#Preview("Goal not met") {
    NavigationStack {
        ActivityContent(snapshot: Fixtures.goalNotMet.snapshot, calendar: Fixtures.calendar)
    }
}
