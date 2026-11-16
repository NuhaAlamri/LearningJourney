import Foundation

/// منطق شاشة التقويم: أي شهور تنعرض، ولون كل يوم
@Observable
final class CalendarViewModel {

    /// الشهور من أول هدف لين 12 شهر بعد الشهر الحالي
    func months(from firstStart: Date?, to now: Date, ahead: Int = 12,
                calendar: Calendar = .current) -> [Date] {
        let end = calendar.date(byAdding: .month, value: ahead, to: now) ?? now
        return CalendarMath.months(from: firstStart ?? now, to: end, calendar: calendar)
    }

    /// أول يوم في الشهر الحالي، عشان الشاشة تفتح عليه
    func currentMonth(_ now: Date, calendar: Calendar = .current) -> Date? {
        calendar.dateInterval(of: .month, for: now)?.start
    }

    /// قاموس: اليوم ← نوع تسجيله، من كل الأهداف
    func dayKinds(from logs: [DayLog]) -> [Date: DayLog.Kind] {
        Dictionary(logs.map { ($0.day, $0.kind) },
                   uniquingKeysWith: { _, latest in latest })
    }
}
