import SwiftUI
import SwiftData

/// شاشة Activities: كل الشهور بألوان الأيام من كل الأهداف
struct CalendarView: View {
    @Query(sort: \Goal.startDate) private var goals: [Goal]
    @Query private var logs: [DayLog]
    @State private var viewModel = CalendarViewModel()
    @State private var monthsAhead = 12

    var calendar: Calendar = .current

    var body: some View {
        let kinds = viewModel.dayKinds(from: logs)
        let months = viewModel.months(from: goals.first?.startDate, to: .now,
                                      ahead: monthsAhead, calendar: calendar)
        let current = viewModel.currentMonth(.now, calendar: calendar)
        let symbols = CalendarMath.weekdaySymbols(short: true, calendar: calendar)

        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(months, id: \.self) { month in
                        VStack(spacing: 8) {
                            MonthGridView(
                                month: month,
                                symbols: symbols,
                                status: { day in DayStatus(kind: kinds[day], isToday: false) },
                                calendar: calendar
                            )
                            if month != months.last {
                                Divider()
                            }
                        }
                        .padding(.top, 15)
                        .id(month)
                        .onAppear {
                            if month == months.last {
                                monthsAhead += 12
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 16)
            }
            .onAppear {
                if let current {
                    proxy.scrollTo(current, anchor: .top)
                }
            }
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
