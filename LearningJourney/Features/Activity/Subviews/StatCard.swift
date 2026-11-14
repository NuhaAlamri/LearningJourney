import SwiftUI

/// بطاقة عدّاد: أيقونة + عدد الأيام + تسمية
struct StatCard: View {
    let symbol: String
    let tint: Color
    let count: Int
    let label: LocalizedStringKey

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.subheadline.bold())
                .foregroundStyle(tint)
                .accessibilityHidden(true)

            VStack(spacing: 4) {
                Text("\(count) days")
                    .font(.callout.weight(.semibold))
                    .contentTransition(.numericText())
                    .animation(.default, value: count)
                Text(label)
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(.card, in: .rect(cornerRadius: 34, style: .continuous))
        .glassEffect(.regular, in: .rect(cornerRadius: 34, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

extension StatCard {
    /// بطاقة السلسلة 🔥
    static func learned(_ count: Int) -> StatCard {
        StatCard(symbol: "flame.fill", tint: .learned, count: count, label: "Learned")
    }

    /// بطاقة التجميد ❄️
    static func freezed(_ count: Int) -> StatCard {
        StatCard(symbol: "snowflake", tint: .freeze, count: count, label: "Freezed")
    }
}

#Preview {
    HStack(spacing: 12) {
        StatCard.learned(4)
        StatCard.freezed(1)
    }
    .padding()
}
