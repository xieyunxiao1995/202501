import SwiftUI
import SwiftData

struct DiscoverView: View {
    private let catalog = ContentRepository.shared
    @Query(sort: \JourneyProgress.updatedAt, order: .reverse) private var progresses: [JourneyProgress]
    @AppStorage("tideverse.savedCharacters") private var savedCharacters = ""
    @AppStorage("tideverse.hiddenCharacters") private var hiddenCharacters = ""
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var search = ""
    @State private var selectedGenre = "All"
    @State private var savedOnly = false
    @State private var readingStatus = "All stories"
    private let readingStatuses = ["All stories", "Not started", "In progress", "Completed"]
    private var query: String { search.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var hasContentFilters: Bool { savedOnly || selectedGenre != "All" || readingStatus != "All stories" }
    private var hasFilters: Bool { !query.isEmpty || hasContentFilters }

    private func matchesReadingStatus(_ character: CharacterDefinition) -> Bool {
        let progress = progresses.first { $0.storyID == character.storyID }
        switch readingStatus {
        case "Not started": return progress == nil
        case "In progress": return progress != nil && progress?.isComplete == false
        case "Completed": return progress?.isComplete == true
        default: return true
        }
    }

    private func resetFilters() {
        search = ""
        selectedGenre = "All"
        savedOnly = false
        readingStatus = "All stories"
    }

    private var hidden: Set<String> { Set(hiddenCharacters.split(separator: ",").map(String.init)) }
    private var saved: Set<String> { Set(savedCharacters.split(separator: ",").map(String.init)) }
    private var available: [CharacterDefinition] { catalog.characters.filter { !hidden.contains($0.id) } }
    private var genres: [String] { ["All"] + Array(Set(available.map(\.genre))).sorted() }
    private var filtered: [CharacterDefinition] {
        available.filter { character in
            (selectedGenre == "All" || character.genre == selectedGenre) &&
            (!savedOnly || saved.contains(character.id)) && matchesReadingStatus(character) &&
            (query.isEmpty || "\(character.name) \(character.profession) \(character.storyTitle) \(character.genre)".localizedStandardContains(query))
        }
    }
    private var featured: CharacterDefinition? {
        for progress in progresses where !progress.isComplete {
            if let character = available.first(where: { $0.storyID == progress.storyID }) { return character }
        }
        return available.first
    }

    var body: some View {
        VStack(spacing: 0) {
            TideSearchField(prompt: "Search stories", text: $search)
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    if query.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Find your next story.").font(.title.bold())
                            Text("Original worlds. Thoughtful choices. Characters worth getting to know.")
                                .font(.subheadline).foregroundStyle(TideColors.muted)
                        }
                    }
                    if !hasFilters, let featured,
                       let story = catalog.story(for: featured) {
                        NavigationLink {
                            StoryDetailView(story: story, character: featured)
                        } label: {
                            DiscoverHeroCard(story: story, character: featured,
                                             progress: progresses.first { $0.storyID == story.id })
                        }
                        .buttonStyle(TideCardButtonStyle())
                    }
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(query.isEmpty ? "Meet the characters" : "Results").font(.title2.bold()).accessibilityIdentifier("discoverCatalogHeading")
                            Spacer()
                            Text("\(filtered.count)").font(.subheadline.monospacedDigit()).foregroundStyle(TideColors.muted)
                                .contentTransition(reduceMotion ? .identity : .numericText())
                                .animation(TideMotion.feedback(reduced: reduceMotion), value: filtered.count)
                        }
                        if query.isEmpty {
                            filterControls
                        } else {
                            DisclosureGroup(hasContentFilters ? "Filters active" : "Filter results") { filterControls }
                                .font(.subheadline)
                        }
                    }
                    if hasFilters, query.isEmpty {
                        Button("Clear filters", systemImage: "arrow.counterclockwise", action: resetFilters)
                            .font(.subheadline)
                            .frame(minHeight: 44)
                    }
                    if filtered.isEmpty {
                        ContentUnavailableView {
                            Label("No characters found", systemImage: "sparkle.magnifyingglass")
                        } description: {
                            Text("Try another genre or reading status. Hidden characters can be restored in Settings.")
                        } actions: {
                            if hasFilters {
                                Button("Clear filters", action: resetFilters)
                                    .buttonStyle(.borderedProminent)
                                    .accessibilityIdentifier("clearDiscoverFilters")
                            }
                        }
                    } else {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: typeSize.isAccessibilitySize ? 280 : 155), spacing: 14)], spacing: 16) {
                            ForEach(filtered) { character in
                                NavigationLink { CharacterDetailView(character: character) } label: {
                                    CharacterCard(character: character, isSaved: saved.contains(character.id),
                                                  progress: progresses.first { $0.storyID == character.storyID })
                                }
                                .accessibilityIdentifier("character_\(character.id)")
                                .buttonStyle(TideCardButtonStyle())
                                .transition(TideMotion.row(reduced: reduceMotion))
                            }
                        }
                        .animation(TideMotion.arrival(reduced: reduceMotion), value: selectedGenre)
                        .animation(TideMotion.arrival(reduced: reduceMotion), value: readingStatus)
                        .animation(TideMotion.arrival(reduced: reduceMotion), value: savedOnly)
                    }
                    Label("Fictional adults · Offline journeys · Optional AI chats", systemImage: "hand.raised")
                        .font(.footnote).foregroundStyle(TideColors.muted)
                        .padding(.vertical, 8)
                }
                .padding(20)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .tideBackground()
        .tideNavigationTitle("Discover", subtitle: "\(catalog.characters.count) fictional characters", symbol: "sparkles")
    }
    private var filterControls: some View {
        VStack(alignment: .leading, spacing: 14) {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(genres, id: \.self) { genre in
                        Button { selectedGenre = genre } label: {
                            Label(genre, systemImage: selectedGenre == genre ? "checkmark" : "circle")
                                .labelStyle(.titleAndIcon).font(.subheadline.weight(.semibold))
                                .padding(.horizontal, 17).frame(minHeight: 44)
                                .foregroundStyle(selectedGenre == genre ? TideColors.canvas : TideColors.ink)
                                .background(selectedGenre == genre ? TideColors.bright : TideColors.soft, in: Capsule())
                        }
                        .buttonStyle(.plain)
                        .accessibilityAddTraits(selectedGenre == genre ? .isSelected : [])
                    }
                }
            }
            .scrollIndicators(.hidden)
            HStack(spacing: 12) {
                Picker("Reading progress", selection: $readingStatus) {
                    ForEach(readingStatuses, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(.menu)
                .frame(minHeight: 44)
                .accessibilityIdentifier("readingStatusFilter")
                Spacer(minLength: 0)
                Toggle(isOn: $savedOnly) { Label("Saved", systemImage: "bookmark") }
                    .toggleStyle(.button).font(.subheadline)
                    .frame(minHeight: 44)
                    .accessibilityLabel("Saved characters")
            }
        }
    }

}
