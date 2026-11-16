import SwiftUI

/// شريط الأسبوع: حرف اليوم + دائرة الرقم
struct WeekStripView: View {
    let days: [Date]
    let symbols: [String]
    let status: (Date) -> DayStatus
    var calendar: Calendar = .current

    var body: some View {
        HStack(spacing: 0) {
            ForEach(days.indices, id: \.self) { index in
                let day = days[index]
                VStack(spacing: 4) {
                    Text(symbols[index])
                        .font(.footnote.weight(.semibold))
                        .accessibilityHidden(true)

                    DayCell(
                        day: calendar.component(.day, from: day),
                        status: status(day),
                        size: 44,
                        date: day
                    )
                }
                .frame(maxWidth: .infinity)
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

#Preview {
    let calendar = Fixtures.calendar
    let today = Fixtures.october(24)
    WeekStripView(
        days: CalendarMath.weekDays(containing: today, calendar: calendar),
        symbols: CalendarMath.weekdaySymbols(calendar: calendar),
        status: { day in
            switch calendar.component(.day, from: day) {
            case 20...23: .learned
            case 24:      .todayPending
            default:      .plain
            }
        },
        calendar: calendar
    )
    .padding()
}
