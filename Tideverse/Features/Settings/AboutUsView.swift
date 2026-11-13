import SwiftUI

struct AboutUsView: View {
    private let catalog = ContentRepository.shared
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Color.clear
                    .frame(height: 188)
                    .overlay { Image("mira_scene").resizable().scaledToFill() }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .accessibilityHidden(true)
                Eyebrow(title: "About our world")
                Text("Tideverse").font(.largeTitle.bold())
                Text("By \(AppConfiguration.studioName)")
                    .font(.subheadline.weight(.medium)).foregroundStyle(TideColors.muted)
                Text("Every conversation shapes a story.")
                    .font(.title3.weight(.medium)).foregroundStyle(TideColors.primary)
                Text("Tideverse is an interactive world of original fictional AI characters, guided story journeys, and memories you control. The story chapters are written and bundled with the app; optional online conversations bring the characters' distinct voices to life.")
                Divider()
                Label("\(catalog.characters.count) original fictional adults (age 25+)", systemImage: "person.3")
                Label("\(catalog.chapterCount) authored chapters and \(catalog.outcomeCount) narrative outcomes", systemImage: "book.pages")
                Label("Local-first Story Moments and Memory Ledger", systemImage: "lock.shield")
                Label("Native iPhone experience", systemImage: "iphone")
                Divider()
                Text("Stories with a memory").font(.headline)
                Text("Choose a direction in each chapter and follow the consequences into later acts. Revisit your decisions in Journeys, keep a favorite scene as a Story Moment, or export it as a readable PDF.")
                Text("A place you control").font(.headline)
                Text("No account or password is required. Your bundled journeys are available offline, your progress stays on your device, and you choose whether to enable online AI conversations.")
                Text("Responsible design").font(.headline)
                Text("Characters are clearly labeled as artificial and fictional. AI responses may be incorrect, and no character should be considered a professional advisor or a real-life companion. Users decide what memories are saved and when cloud AI is enabled.")
                    .foregroundStyle(.secondary)
                Text("App version \(AppConfiguration.version) (\(AppConfiguration.build))")
                    .font(.caption).foregroundStyle(.secondary)
            }
            .padding(20)
        }
        .tideBackground()
        .tideNavigationTitle("About Us")
    }
}
