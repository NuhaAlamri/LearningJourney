import SwiftUI

/// حالة خلية اليوم
enum DayStatus: Equatable {
    case plain          // يوم عادي: جاي، أو فات بدون تسجيل
    case learned        // تعلّم فيه
    case freezed        // جمّد فيه
    case todayPending   // اليوم، وما سجّل للحين
}

extension DayStatus {
    /// يحوّل نوع التسجيل إلى حالة خلية
    init(kind: DayLog.Kind?, isToday: Bool) {
        switch kind {
        case .learned: self = .learned
        case .freezed: self = .freezed
        case nil:      self = isToday ? .todayPending : .plain
        }
    }

    /// اللي يقرأه VoiceOver بعد التاريخ
    var accessibilityValue: String {
        switch self {
        case .plain:        ""
        case .learned:      String(localized: "Learned")
        case .freezed:      String(localized: "Freezed")
        case .todayPending: String(localized: "Not logged yet")
        }
    }
}

/// خلية يوم دائرية، مثل Sketch
struct DayCell: View {
    let day: Int
    let status: DayStatus
    var size: CGFloat = 38
    var date: Date? = nil

    @ScaledMetric(relativeTo: .title3) private var scale: CGFloat = 1

    var body: some View {
        Text(day, format: .number)
            .font(.title3.weight(fontWeight))
            .foregroundStyle(textColor)
            .frame(width: size * scale, height: size * scale)
            .background(background, in: .circle)
            .accessibilityLabel(accessibilityLabel)
            .accessibilityValue(status.accessibilityValue)
    }

    private var accessibilityLabel: Text {
        if let date {
            Text(date, format: .dateTime.weekday(.wide).day().month(.wide))
        } else {
            Text(day, format: .number)
        }
    }

    private var textColor: Color {
        switch status {
        case .plain:        .primary
        case .learned:      .learned
        case .freezed:      .freeze
        case .todayPending: .white
        }
    }

    private var background: Color {
        switch status {
        case .plain:        .clear
        case .learned:      .learned.opacity(0.12)
        case .freezed:      .freeze.opacity(0.12)
        case .todayPending: .learned
        }
    }

    private var fontWeight: Font.Weight {
        switch status {
        case .plain:             .regular
        case .learned, .freezed: .medium
        case .todayPending:      .semibold
        }
    }
}

#Preview {
    HStack(spacing: 6) {
        DayCell(day: 20, status: .learned)
        DayCell(day: 23, status: .freezed)
        DayCell(day: 24, status: .todayPending)
        DayCell(day: 25, status: .plain)
    }
    .padding()
}
