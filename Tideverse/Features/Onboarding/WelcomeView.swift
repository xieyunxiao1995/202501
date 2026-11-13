import SwiftUI

struct WelcomeView: View {
    let onContinue: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var page = 0
    private let catalog = ContentRepository.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TabView(selection: $page) {
                    OnboardingPageView(
                        image: "vera_scene", title: "Find a world worth entering.",
                        message: "Meet \(catalog.characters.count) original fictional adult characters, each with a history, a voice, and a journey of their own.",
                        feature: "Illustrated worlds, ready to explore", symbol: "sparkles"
                    ).tag(0)
                    OnboardingPageView(
                        image: "anika_scene", title: "Your choices leave a trace.",
                        message: "Explore \(catalog.chapterCount) authored chapters. Make a choice, see its consequences, and discover how later scenes remember your path.",
                        feature: "Play offline. Return to saved progress.", symbol: "book.pages"
                    ).tag(1)
                    OnboardingPageView(
                        image: "rhea_scene", title: "Keep the story. Keep control.",
                        message: "Save Story Moments, export them as PDFs, and choose which memories to keep. Live AI is optional and needs separate permission before data is sent.",
                        feature: "No account or password required", symbol: "hand.raised"
                    ).tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                VStack(spacing: 16) {
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Capsule().fill(page == index ? TideColors.bright : TideColors.border)
                                .frame(width: page == index ? 24 : 8, height: 8)
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Introduction page \(page + 1) of 3")
                    TidePrimaryButton(title: page == 2 ? "Continue to welcome" : "Next", systemImage: "arrow.right") {
                        if page == 2 { onContinue() }
                        else { withAnimation(TideMotion.arrival(reduced: reduceMotion)) { page += 1 } }
                    }
                    .accessibilityIdentifier(page == 2 ? "beginExploring" : "introNext")
                }
                .padding(.horizontal, 24).padding(.top, 12).padding(.bottom, 16)
            }
            .tideBackground()
            .tideNavigationTitle("Tideverse")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip introduction", action: onContinue)
                        .accessibilityIdentifier("skipIntroduction")
                }
            }
        }
    }
}
