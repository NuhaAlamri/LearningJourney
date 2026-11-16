import Foundation

/// منطق شاشة التقويم: أي شهور تنعرض، ولون كل يوم
@Observable
final class CalendarViewModel {

    /// الشهور من أول هدف لين الشهر الحالي
    func months(from firstStart: Date?, to now: Date, calendar: Calendar = .current) -> [Date] {
        CalendarMath.months(from: firstStart ?? now, to: now, calendar: calendar)
    }

    /// قاموس: اليوم ← نوع تسجيله، من كل الأهداف
    func dayKinds(from logs: [DayLog]) -> [Date: DayLog.Kind] {
        Dictionary(logs.map { ($0.day, $0.kind) },
                   uniquingKeysWith: { _, latest in latest })
    }
}
