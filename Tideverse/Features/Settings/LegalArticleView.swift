import SwiftUI

struct LegalArticleView: View {
    let title: String
    let intro: String
    let sections: [(String, String)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 17) {
                Text(title).font(.largeTitle.bold()).foregroundStyle(TideColors.deep)
                Text(intro).font(.subheadline).foregroundStyle(.secondary)
                if let publisher = AppConfiguration.publisherName {
                    Text("Publisher: \(publisher)").font(.footnote).foregroundStyle(TideColors.muted)
                }
                if let date = AppConfiguration.legalEffectiveDate {
                    Text("Effective: \(date)").font(.footnote).foregroundStyle(TideColors.muted)
                }
                if title == "Privacy Policy", let url = AppConfiguration.privacyPolicyURL {
                    Link("Read the published privacy policy", destination: url)
                }
                Divider()
                ForEach(sections.indices, id: \.self) { index in
                    Text(sections[index].0).font(.headline)
                    Text(sections[index].1)
                        .font(.body)
                        .lineSpacing(4)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
        }
        .tideBackground()
        .tideNavigationTitle(title)
    }
}
