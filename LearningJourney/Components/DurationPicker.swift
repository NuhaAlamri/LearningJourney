import SwiftUI

/// اختيار مدة الهدف: Week / Month / Year
struct DurationPicker: View {
    @Binding var selection: GoalDuration

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) { buttons }
            VStack(alignment: .leading, spacing: 12) { buttons }
        }
        .controlSize(.large)
        .buttonBorderShape(.capsule)
        .animation(.snappy, value: selection)
        .sensoryFeedback(.selection, trigger: selection)
    }

    private var buttons: some View {
        ForEach(GoalDuration.allCases) { duration in
            button(for: duration)
                .accessibilityAddTraits(duration == selection ? .isSelected : [])
        }
    }

    @ViewBuilder
    private func button(for duration: GoalDuration) -> some View {
        let isSelected = duration == selection

        let button = Button {
            selection = duration
        } label: {
            Text(duration.title)
                .font(.body.weight(.medium))
                .foregroundStyle(isSelected ? Color.white : Color.secondary)
        }

        if isSelected {
            button
                .buttonStyle(.glassProminent)
                .tint(.learned)
        } else {
            button
                .buttonStyle(.glass)
        }
    }
}

#Preview {
    @Previewable @State var selection = GoalDuration.week
    DurationPicker(selection: $selection)
        .padding()
}
