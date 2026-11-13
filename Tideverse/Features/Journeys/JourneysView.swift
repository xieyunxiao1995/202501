import SwiftUI
import SwiftData

struct JourneysView: View {
    private let catalog = ContentRepository.shared
    @Query(sort: \JourneyProgress.updatedAt, order: .reverse) private var progresses: [JourneyProgress]
    @Query(sort: \StoryMoment.createdAt, order: .reverse) private var moments: [StoryMoment]
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var librarySection = "Journeys"
    @State private var selection = "All journeys"
    @State private var search = ""
    @Environment(\.dynamicTypeSize) private var typeSize
    private var query: String { search.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var hasFilters: Bool { !query.isEmpty || selection != "All journeys" }

    private let filters = ["All journeys", "In progress", "Completed", "Not started"]

    private var visibleStories: [StoryDefinition] {
        catalog.stories.filter { story in
            let progress = progresses.first { $0.storyID == story.id }
            let matchesStatus = selection == "All journeys" ||
                (selection == "In progress" && progress != nil && progress?.isComplete == false) ||
                (selection == "Completed" && progress?.isComplete == true) ||
                (selection == "Not started" && progress == nil)
            return matchesStatus && (query.isEmpty || "\(story.title) \(catalog.character(id: story.characterID)?.name ?? "")".localizedStandardContains(query))
        }.sorted { a, b in
            let dateA = progresses.first { $0.storyID == a.id }?.updatedAt ?? .distantPast
            let dateB = progresses.first { $0.storyID == b.id }?.updatedAt ?? .distantPast
            return dateA == dateB ? a.title < b.title : dateA > dateB
        }
    }
    private var visibleMoments: [StoryMoment] {
        moments.filter { query.isEmpty || "\($0.title) \($0.decision) \($0.recap) \(catalog.character(id: $0.characterID)?.name ?? "")".localizedStandardContains(query) }
    }

    var body: some View {
        VStack(spacing: 0) {
            TideSearchField(prompt: "Search library", text: $search)
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Stories stay with you.").font(.title.bold())
                        Text("Continue a journey, revisit a decision, or keep a moment as a PDF. Everything here is saved on this device.")
                            .font(.subheadline).foregroundStyle(TideColors.muted)
                    }
                    let statisticsLayout = typeSize.isAccessibilitySize
                        ? AnyLayout(VStackLayout(alignment: .leading, spacing: 12))
                        : AnyLayout(HStackLayout(alignment: .top, spacing: 12))
                    statisticsLayout {
                        JourneyStatistic(value: progresses.filter { !$0.isComplete }.count, title: "In progress", symbol: "book")
                        JourneyStatistic(value: progresses.filter(\.isComplete).count, title: "Completed", symbol: "checkmark.seal")
                        JourneyStatistic(value: moments.count, title: "Moments", symbol: "sparkles.rectangle.stack")
                    }
                    Picker("Library section", selection: $librarySection) {
                        Text("Journeys").tag("Journeys")
                        Text("Moments").tag("Moments")
                    }
                    .pickerStyle(.segmented)
                    .accessibilityIdentifier("librarySection")
                    if librarySection == "Journeys" || !query.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your library").font(.title2.bold()).accessibilityIdentifier("libraryHeading")
                        Picker("Show journeys", selection: $selection) {
                            ForEach(filters, id: \.self) { Text($0).tag($0) }
                        }
                        .pickerStyle(.menu)
                    }
                    if hasFilters {
                        Button("Clear library filters", systemImage: "arrow.counterclockwise") {
                            search = ""
                            selection = "All journeys"
                        }
                        .frame(minHeight: 44)
                    }
                    if visibleStories.isEmpty && (query.isEmpty || visibleMoments.isEmpty) {
                        ContentUnavailableView("No matching journeys", systemImage: "books.vertical",
                                               description: Text("Clear the search or choose another reading status to explore your library."))
                    }
                    ForEach(visibleStories) { story in
                        if let character = catalog.character(id: story.characterID) {
                            NavigationLink { StoryDetailView(story: story, character: character) } label: {
                                JourneyRow(story: story, character: character,
                                           progress: StoryEngine.progress(for: story, in: progresses))
                            }
                            .buttonStyle(TideCardButtonStyle())
                        }
                    }
                    }
                    if librarySection == "Moments" || !query.isEmpty {
                    Text("Story Moments").font(.title2.bold()).padding(.top, 8)
                    if visibleMoments.isEmpty {
                        ContentUnavailableView(query.isEmpty ? "A moment starts with a choice" : "No matching moments",
                                               systemImage: query.isEmpty ? "sparkles.rectangle.stack" : "magnifyingglass",
                                               description: Text(query.isEmpty
                                                   ? "Choose an option in a chapter to save a moment you can revisit and export."
                                                   : "Try a character name, chapter title, or words from your decision."))
                    }
                    ForEach(visibleMoments) { moment in
                        NavigationLink { StoryMomentDetailView(moment: moment) } label: { MomentRow(moment: moment) }
                            .buttonStyle(TideCardButtonStyle())
                            .accessibilityIdentifier("moment_\(moment.chapterID)")
                    }
                    }
                }
                .padding(20)
                .animation(TideMotion.panel(reduced: reduceMotion), value: librarySection)
                .animation(TideMotion.arrival(reduced: reduceMotion), value: selection)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .tideBackground()
        .tideNavigationTitle("Journeys", subtitle: "Your story library", symbol: "book.closed")
    }
}
