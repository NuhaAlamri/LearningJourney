import SwiftUI
import SwiftData

/// أول شاشة: ترحيب + أول هدف
struct OnboardingView: View {
    @Environment(\.modelContext) private var context
    @State private var viewModel = OnboardingViewModel()

    @ScaledMetric(relativeTo: .largeTitle) private var iconSize: CGFloat = 36

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(systemName: "flame.fill")
                    .font(.system(size: iconSize, weight: .bold))
                    .foregroundStyle(.learned)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 56)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello \(Text("Learner").bold())")
                        .font(.largeTitle)
                    Text("This app will help you learn every day!")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 80)

                GoalFormView(draft: $viewModel.draft)
                    .padding(.top, 37)
            }
            .padding(.horizontal, 16)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                Button {
                    viewModel.start(in: context)
                } label: {
                    Text("Start Learning")
                }
                .prominentGlassButton()
                .disabled(!viewModel.draft.isValid)

                Text("You can edit your desire later")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 8)
        }
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: [Goal.self, DayLog.self], inMemory: true)
}
