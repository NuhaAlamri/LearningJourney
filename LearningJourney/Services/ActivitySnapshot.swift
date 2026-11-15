import Foundation

/// كل اللي تحتاجه شاشة Activity، محسوب وجاهز
struct ActivitySnapshot: Equatable {

    enum GoalState: Equatable {
        case active      // الهدف شغّال
        case completed   // انتهى بنجاح ← "Well done!"
        case notMet      // انتهى بدون نجاح ← "You didn't reach your goal"
    }

    let today: Date
    let streak: Int          // كل أيام السلسلة (Learned + Freezed): للمنطق
    let learnedDays: Int     // أيام Learned بس في السلسلة: للعرض
    let freezesUsed: Int
    let freezeLimit: Int
    let todayKind: DayLog.Kind?
    let goalState: GoalState
    let dayKinds: [Date: DayLog.Kind]
    let todayLoggedInOtherGoal: Bool

    /// زر "Log as Learned" شغّال؟
    var canLog: Bool {
        goalState == .active && todayKind == nil && !todayLoggedInOtherGoal
    }

    /// زر "Freeze for a day" شغّال؟
    var canFreeze: Bool { canLog && freezesUsed < freezeLimit }

    /// نوع التسجيل في يوم معيّن، عشان نلوّن شريط الأسبوع
    func kind(on day: Date) -> DayLog.Kind? { dayKinds[day] }
}
