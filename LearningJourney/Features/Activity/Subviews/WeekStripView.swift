import SwiftUI

/// شريط الأسبوع: حروف الأيام فوق سبع خلايا
struct WeekStripView: View {
    let days: [Date]
    let symbols: [String]
    let status: (Date) -> DayStatus
    var calendar: Calendar = .current

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                ForEach(symbols.indices, id: \.self) { index in
                    Text(symbols[index])
                        .font(.footnote.weight(.semibold))
                        .frame(maxWidth: .infinity)
                }
            }
            .accessibilityHidden(true)

            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    DayCell(day: calendar.component(.day, from: day), status: status(day), date: day)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    let calendar = Fixtures.calendar
    let days = CalendarMath.weekDays(containing: Fixtures.october(24), calendar: calendar)

    WeekStripView(
        days: days,
        symbols: CalendarMath.weekdaySymbols(calendar: calendar),
        status: { day in
            switch calendar.component(.day, from: day) {
            case 20...22: .learned
            case 23:      .freezed
            case 24:      .todayPending
            default:      .plain
            }
        },
        calendar: calendar
    )
    .padding()
}
