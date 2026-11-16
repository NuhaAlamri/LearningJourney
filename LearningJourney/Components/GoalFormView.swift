import SwiftUI

/// نموذج الهدف: الموضوع + المدة (Onboarding وتعديل الهدف)
struct GoalFormView: View {
    @Binding var draft: GoalDraft
    @FocusState private var isTopicFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("I want to learn")
                .font(.callout)

            TextField("Swift", text: $draft.topic)
                .font(.body.weight(.medium))
                .focused($isTopicFocused)
                .submitLabel(.done)
                .autocorrectionDisabled()
                .padding(.top, 19)

            Divider()
                .padding(.top, 14)

            Text("I want to learn it in a")
                .font(.callout)
                .padding(.top, 30)

            DurationPicker(selection: $draft.duration)
                .padding(.top, 13)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onChange(of: draft.duration) {
            isTopicFocused = false
        }
    }
}

#Preview {
    @Previewable @State var draft = GoalDraft()
    VStack(spacing: 40) {
        GoalFormView(draft: $draft)
        Text(verbatim: draft.isValid ? "✓ Valid" : "✗ Empty")   // للتجربة فقط
    }
    .padding()
}
