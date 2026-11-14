import SwiftUI
/// الشاشات اللي نقدر ننتقل لها من Activity
enum Route: Hashable {
    case calendar   // التقويم
    case editGoal   // تعديل الهدف الحالي (Update)
    case newGoal    // هدف جديد بعد انتهاء الحالي (Set a goal)
}
