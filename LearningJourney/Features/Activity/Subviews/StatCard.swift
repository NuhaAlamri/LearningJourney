import SwiftUI

/// بطاقة إحصائية: أيقونة + "4 days" + "Learned"
struct StatCard: View {
    let value: Int
    let title: LocalizedStringKey
    let systemImage: String
    let tint: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(tint)
                .frame(height: 25)

            VStack(spacing: 4) {
                Text("\(value) days")
                    .font(.callout.weight(.semibold))
                    .contentTransition(.numericText(value: Double(value)))
                    .monospacedDigit()

                Text(title)
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 74)
        .padding(14)
        .glassEffect(.regular, in: .rect(cornerRadius: 34, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

extension StatCard {
    static func learned(_ days: Int) -> StatCard {
        StatCard(value: days, title: "Learned", systemImage: "flame.fill", tint: .learned)
    }

    static func freezed(_ days: Int) -> StatCard {
        StatCard(value: days, title: "Freezed", systemImage: "snowflake", tint: .freeze)
    }
}

#Preview {
    HStack(spacing: 12) {
        StatCard.learned(4)
        StatCard.freezed(0)
    }
    .padding()
}
