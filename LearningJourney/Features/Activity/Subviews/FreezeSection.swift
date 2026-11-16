import SwiftUI

/// زر التجميد + عدّاد التجميدات
struct FreezeSection: View {
    let canFreeze: Bool
    let isFreezedToday: Bool
    let used: Int
    let limit: Int
    let action: () -> Void

    @ScaledMetric(relativeTo: .subheadline) private var counterSize: CGFloat = 14

    private var title: LocalizedStringKey {
        isFreezedToday ? "Freezed for a day" : "Freeze for a day"
    }

    var body: some View {
        VStack(spacing: 16) {
            Button(action: action) {
                Text(title)
                    .frame(maxWidth: .infinity)
            }
            .prominentGlassButton(tint: .freeze)
            .disabled(!canFreeze)
            .frame(maxWidth: 272)
            .sensoryFeedback(.success, trigger: isFreezedToday) { old, new in !old && new }

            Text("\(used) out of \(limit) Freezes used")
                .font(.system(size: counterSize))
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        FreezeSection(canFreeze: true, isFreezedToday: false, used: 0, limit: 2) {}
        FreezeSection(canFreeze: false, isFreezedToday: true, used: 1, limit: 2) {}
    }
    .padding()
}
