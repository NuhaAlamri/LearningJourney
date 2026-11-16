import SwiftUI

extension View {
    /// أسلوب أزرار التطبيق الأساسية: كبسولة زجاج ملوّنة (Glass Prominent في Sketch)
    func prominentGlassButton(tint: Color = .learned) -> some View {
        self
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .font(.body.weight(.medium))
            .tint(tint)
    }
}
