import SwiftUI

/// نموذج الهدف: الموضوع + المدة (Onboarding وتعديل الهدف)
struct GoalFormView: View {
    @Binding var draft: GoalDraft
    @FocusState private var isTopicFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {

            VStack(alignment: .leading, spacing: 12) {
                Text("I want to learn")
                    .font(.callout)
                TextField("Swift", text: $draft.topic)
                    .focused($isTopicFocused)
                    .submitLabel(.done)
                    .autocorrectionDisabled()
                Divider()
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("I want to learn it in a")
                    .font(.callout)
                DurationPicker(selection: $draft.duration)
            }
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
