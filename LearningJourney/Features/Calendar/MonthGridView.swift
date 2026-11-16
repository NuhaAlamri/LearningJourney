import SwiftUI

/// شهر واحد: العنوان + حروف الأيام + شبكة الأيام
struct MonthGridView: View {
    let month: Date
    let symbols: [String]
    let status: (Date) -> DayStatus
    var calendar: Calendar = .current

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(month, format: .dateTime.month(.wide).year())
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

                        LazyVGrid(columns: columns, spacing: 8) {
                ForEach(symbols.indices, id: \.self) { index in
                    Text(symbols[index])
                    .font(.footnote.weight(.semibold))
                    .textCase(.uppercase)
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                }

                ForEach(0..<CalendarMath.leadingBlanks(for: month, calendar: calendar), id: \.self) { _ in
                    Color.clear
                        .frame(width: 1, height: 1)
                }

                    ForEach(CalendarMath.days(inMonth: month, calendar: calendar), id: \.self) { day in
                        DayCell(day: calendar.component(.day, from: day), status: status(day), date: day)
                }
            }
        }
    }
}

#Preview {
    let calendar = Fixtures.calendar
    MonthGridView(
        month: Fixtures.october(1),
        symbols: CalendarMath.weekdaySymbols(calendar: calendar),
        status: { day in
            switch calendar.component(.day, from: day) {
            case 20...22: .learned
            case 23, 24:  .freezed
            default:      .plain
            }
        },
        calendar: calendar
    )
    .padding()
}
