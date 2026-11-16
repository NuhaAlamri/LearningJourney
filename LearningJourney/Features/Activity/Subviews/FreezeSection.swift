import SwiftUI

/// زر التجميد + عدّاد الرصيد
struct FreezeSection: View {
    let canFreeze: Bool
    let isFreezedToday: Bool
    let used: Int
    let limit: Int
    let action: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Button(action: action) {
                Text(title)
                    .frame(maxWidth: 272)
            }
            .prominentGlassButton(tint: .freeze)
            .disabled(!canFreeze)

            Text("\(used) out of \(limit) Freezes used")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .monospacedDigit()
                .contentTransition(.numericText(value: Double(used)))
                .animation(.default, value: used)
            
            
        }
    }

    private var title: LocalizedStringKey {
        isFreezedToday ? "Freezed for a day" : "Freeze for a day"
    }
}

#Preview("Can freeze") {
    FreezeSection(canFreeze: true, isFreezedToday: false, used: 0, limit: 2) {}
        .padding()
}

#Preview("Freezed today") {
    FreezeSection(canFreeze: false, isFreezedToday: true, used: 1, limit: 2) {}
        .padding()
}

#Preview("No freezes left") {
    FreezeSection(canFreeze: false, isFreezedToday: false, used: 2, limit: 2) {}
        .padding()
}
