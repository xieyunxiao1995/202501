import SwiftUI

struct OnboardingPageView: View {
    let image: String
    let title: String
    let message: String
    let feature: String
    let symbol: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Color.clear
                    .frame(height: 245)
                    .overlay {
                        Image(image).resizable().scaledToFill()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .accessibilityHidden(true)
                Text(title).font(.largeTitle.bold()).fixedSize(horizontal: false, vertical: true)
                Text(message).font(.body).foregroundStyle(TideColors.muted).lineSpacing(4)
                Label(feature, systemImage: symbol)
                    .font(.subheadline.weight(.semibold))
                    .padding(18).frame(maxWidth: .infinity, alignment: .leading)
                    .background(TideColors.card, in: RoundedRectangle(cornerRadius: 16))
            }
            .padding(24)
        }
        .scrollIndicators(.hidden)
    }
}
