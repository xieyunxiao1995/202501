import SwiftUI
import SwiftData

struct ChatsView: View {
    @Query(sort: \ChatRecord.createdAt, order: .reverse) private var allMessages: [ChatRecord]
    @AppStorage("tideverse.hiddenCharacters") private var hiddenCharacters = ""
    @State private var search = ""
    private let catalog = ContentRepository.shared
    private var query: String { search.trimmingCharacters(in: .whitespacesAndNewlines) }

    private var latest: [String: ChatRecord] {
        var result: [String: ChatRecord] = [:]
        for message in allMessages where result[message.characterID] == nil { result[message.characterID] = message }
        return result
    }
    private var characters: [CharacterDefinition] {
        let hidden = Set(hiddenCharacters.split(separator: ",").map(String.init))
        return catalog.characters.filter {
            !hidden.contains($0.id) && (query.isEmpty || "\($0.name) \($0.profession)".localizedStandardContains(query))
        }
    }
    private var recent: [CharacterDefinition] {
        let messages = latest
        return characters.filter { messages[$0.id] != nil }.sorted {
            (messages[$0.id]?.createdAt ?? .distantPast) > (messages[$1.id]?.createdAt ?? .distantPast)
        }
    }
    private var newConversations: [CharacterDefinition] { characters.filter { latest[$0.id] == nil } }

    var body: some View {
        VStack(spacing: 0) {
            TideSearchField(prompt: "Search chats", text: $search)
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 18) {
                    if query.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Every world has a voice.").font(.largeTitle.bold())
                            Text("Talk freely, and let the conversation move the story. Describing what you want to do can unlock the chapter’s authored directions.")
                                .font(.subheadline).foregroundStyle(TideColors.muted)
                        }
                    }
                    if !AppConfiguration.isAIConfigured, query.isEmpty {
                        Label("Live AI replies are offline. Authored scenes still let you chat and move the story forward on this device.", systemImage: "wifi.slash")
                            .font(.footnote).foregroundStyle(TideColors.muted)
                            .padding(18).frame(maxWidth: .infinity, alignment: .leading)
                            .background(TideColors.soft, in: RoundedRectangle(cornerRadius: 20))
                    }
                    if !recent.isEmpty {
                        Text("Your conversations").font(.title2.bold())
                        ForEach(recent) { character in
                            NavigationLink { ChatDetailView(character: character) } label: {
                                ChatCharacterRow(character: character, lastMessage: latest[character.id])
                            }
                            .buttonStyle(TideCardButtonStyle())
                            .accessibilityIdentifier("chatCharacter_\(character.id)")
                        }
                    }
                    if !newConversations.isEmpty {
                        Text("Meet someone new").font(.title2.bold())
                        ForEach(newConversations) { character in
                            NavigationLink { ChatDetailView(character: character) } label: {
                                ChatCharacterRow(character: character, lastMessage: nil)
                            }
                            .buttonStyle(TideCardButtonStyle())
                            .accessibilityIdentifier("chatCharacter_\(character.id)")
                        }
                    }
                    if characters.isEmpty {
                        ContentUnavailableView {
                            Label("No conversations found", systemImage: "bubble.left.and.text.bubble.right")
                        } description: {
                            Text("Try another name, or restore hidden characters in Settings.")
                        } actions: {
                            if !query.isEmpty {
                                Button("Clear search") { search = "" }
                            }
                        }
                    }
                }
                .padding(20)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .tideBackground()
        .tideNavigationTitle("Chats", subtitle: "Stories in conversation", symbol: "bubble.left.and.bubble.right")
    }
}
