import SwiftUI
import SwiftData

/// شاشة Activities: كل الشهور بألوان الأيام من كل الأهداف
struct CalendarView: View {
    @Query(sort: \Goal.startDate) private var goals: [Goal]
    @Query private var logs: [DayLog]
    @State private var viewModel = CalendarViewModel()

    var calendar: Calendar = .current

    var body: some View {
        let kinds = viewModel.dayKinds(from: logs)
        let months = viewModel.months(from: goals.first?.startDate, to: .now, calendar: calendar)
        let symbols = CalendarMath.weekdaySymbols(calendar: calendar)

        ScrollView {
            LazyVStack(spacing: 32) {
                ForEach(months, id: \.self) { month in
                    MonthGridView(
                        month: month,
                        symbols: symbols,
                        status: { day in DayStatus(kind: kinds[day], isToday: false) },
                        calendar: calendar
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .navigationTitle("Activities")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview(traits: .sampleData) {
    NavigationStack {
        CalendarView(calendar: Fixtures.calendar)
    }
}
