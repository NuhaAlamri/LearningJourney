import SwiftUI

/// حالة الزر الدائري الكبير
enum LogButtonState: Equatable {
    case ready          // ما سجّل اليوم
    case learnedToday   // سجّل Learned
    case freezedToday   // سجّل Freeze

    init(todayKind: DayLog.Kind?) {
        switch todayKind {
        case nil:      self = .ready
        case .learned: self = .learnedToday
        case .freezed: self = .freezedToday
        }
    }
}

/// الزر الدائري الكبير في Activity
struct LogButton: View {
    let state: LogButtonState
    var isEnabled = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.body.bold())
                .multilineTextAlignment(.center)
                .padding(24)
                .frame(maxWidth: 272, maxHeight: 272)
                .aspectRatio(1, contentMode: .fit)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .tint(tint)
        .disabled(state != .ready || !isEnabled)
        .sensoryFeedback(.success, trigger: state) { _, newState in
            newState != .ready
        }
    }

    private var title: LocalizedStringKey {
        switch state {
        case .ready:        "Log as Learned"
        case .learnedToday: "Logged as Learned"
        case .freezedToday: "Day Freezed"
        }
    }

    private var tint: Color {
        state == .freezedToday ? .freeze : .learned
    }
}

#Preview("Ready") {
    LogButton(state: .ready) {}
        .padding()
}

#Preview("Learned today") {
    LogButton(state: .learnedToday) {}
        .padding()
}

#Preview("Freezed today") {
    LogButton(state: .freezedToday) {}
        .padding()
}
