import SwiftUI

// ألوان التطبيق: كلها من ألوان النظام، فتتغير تلقائياً بين Light وDark
extension ShapeStyle where Self == Color {

    /// لون "تعلّمت اليوم"
    static var learned: Color { .orange }

    /// لون "التجميد"
    static var freeze: Color { .cyan }
}


// جدول الخطوط (Sketch → SwiftUI)
// 34 Regular   "Hello"                        → .largeTitle
// 34 Bold      "Learner" · "Activity"          → .largeTitle.bold()
// 20           رقم اليوم (الأسبوع والتقويم)     → .title3 (الوزن حسب الحالة)
// 17 Regular   النص العادي والتاريخ            → .body
// 17 Medium    الأزرار وحقل الموضوع            → .body.weight(.medium)
// 17 Bold      نص الدائرة الكبيرة              → .body.bold()
// 17 Semibold  اسم الشهر                       → .headline
// 16 Regular   "I want to learn"               → .callout
// 16 Semibold  "3 days"                        → .callout.weight(.semibold)
// 16 Bold      "Well done!"                    → .callout.bold()
// 14 Regular   "1 out of 2 Freezes used"       → @ScaledMetric 14
// 13 Semibold  حروف الأيام S M T               → .footnote.weight(.semibold)
// 13 Medium    "Ready for your next goal?"     → .footnote.weight(.medium)
// 12 Regular   "Learned" · "Freezed" · التلميح → .caption


#Preview("Theme") {
    VStack(spacing: 16) {
        Text("Learned")
            .font(.largeTitle)
            .foregroundStyle(.learned)

        Text("Freezed")
            .font(.largeTitle)
            .foregroundStyle(.freeze)
    }
    .padding()
}
