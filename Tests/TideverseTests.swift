import XCTest
import SwiftData
import UIKit
import PDFKit
import ImageIO
import UniformTypeIdentifiers
@testable import Tideverse

@MainActor
final class TideverseTests: XCTestCase {
    private func deepSeekPayload(image: String? = nil) throws -> GatewayChatRequest {
        let character = try XCTUnwrap(ContentRepository.shared.character(id: "mira"))
        let chapter = try XCTUnwrap(ContentRepository.shared.story(for: character)?.chapters.first)
        return GatewayChatRequest(characterID: character.id, chapterIndex: 0, chapterID: chapter.id,
                                  chapterTitle: chapter.title, storyChoices: [],
                                  recentMessages: [ChatTurn(role: "assistant", text: "The letter waits on the desk.")],
                                  approvedMemories: ["Prefer careful investigation."], message: "Examine the seal.", imageBase64: image)
    }

    func testDeepSeekRequestIncludesPersonaContextAndRequestedOptions() throws {
        let request = try DeepSeekChatAdapter.makeRequest(deepSeekPayload())
        XCTAssertEqual(request.url?.absoluteString, "https://api.deepseek.com/chat/completions")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.value(forHTTPHeaderField: "Authorization")?.hasPrefix("Bearer ") == true)
        let bytes = try XCTUnwrap(request.httpBody)
        let body = try XCTUnwrap(JSONSerialization.jsonObject(with: bytes) as? [String: Any])
        XCTAssertEqual(body["model"] as? String, "deepseek-flash")
        XCTAssertEqual(body["reasoning_effort"] as? String, "high")
        XCTAssertEqual((body["thinking"] as? [String: String])?["type"], "enabled")
        XCTAssertEqual(body["stream"] as? Bool, false)
        let messages = try XCTUnwrap(body["messages"] as? [[String: Any]])
        let system = try XCTUnwrap(messages.first?["content"] as? String)
        XCTAssertTrue(system.contains("Mira Vale"))
        XCTAssertTrue(system.contains("mira_c1_a"))
        XCTAssertTrue(system.contains("Never claim consciousness"))
        XCTAssertTrue(String(decoding: bytes, as: UTF8.self).contains("Prefer careful investigation."))
        XCTAssertFalse(String(decoding: bytes, as: UTF8.self).contains(DeepSeekConfiguration.apiKey ?? "missing"))
    }

    func testDeepSeekSelectedJPEGUsesVisionContentPart() throws {
        let image = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20)).image { _ in
            UIColor.green.setFill(); UIRectFill(CGRect(x: 0, y: 0, width: 20, height: 20))
        }
        let encoded = try XCTUnwrap(image.jpegData(compressionQuality: 0.7)).base64EncodedString()
        let request = try DeepSeekChatAdapter.makeRequest(deepSeekPayload(image: encoded))
        let body = try XCTUnwrap(JSONSerialization.jsonObject(with: try XCTUnwrap(request.httpBody)) as? [String: Any])
        let messages = try XCTUnwrap(body["messages"] as? [[String: Any]])
        let parts = try XCTUnwrap(messages.last?["content"] as? [[String: Any]])
        XCTAssertEqual(parts.count, 2)
        XCTAssertEqual(parts.last?["type"] as? String, "image_url")
        let descriptor = try XCTUnwrap(parts.last?["image_url"] as? [String: String])
        XCTAssertTrue(descriptor["url"]?.hasPrefix("data:image/jpeg;base64,") == true)
    }

    func testDeepSeekHidesReasoningAndValidatesChoiceMarkers() throws {
        let response = Data(#"{"choices":[{"finish_reason":"stop","message":{"content":"Look at the seal. [[choice:forged]] [[choice:mira_c1_a]]","reasoning_content":"PRIVATE_REASONING"}}]}"#.utf8)
        let result = try DeepSeekChatAdapter.parseResponse(response, for: deepSeekPayload())
        XCTAssertEqual(result.reply, "Look at the seal.")
        XCTAssertEqual(result.suggestedChoiceID, "mira_c1_a")
        XCTAssertFalse(result.reply.contains("PRIVATE_REASONING"))
        let forged = Data(#"{"choices":[{"message":{"content":"A quiet room. [[choice:jonah_c1_a]]"}}]}"#.utf8)
        XCTAssertNil(try DeepSeekChatAdapter.parseResponse(forged, for: deepSeekPayload()).suggestedChoiceID)
    }

    func testDeepSeekRejectsTruncatedEmptyAndInvalidCanonicalReplies() throws {
        let truncated = Data(#"{"choices":[{"finish_reason":"length","message":{"content":"An unfinished reply"}}]}"#.utf8)
        XCTAssertThrowsError(try DeepSeekChatAdapter.parseResponse(truncated, for: deepSeekPayload()))
        let reasoningOnly = Data(#"{"choices":[{"message":{"content":null,"reasoning_content":"Hidden thoughts"}}]}"#.utf8)
        XCTAssertThrowsError(try DeepSeekChatAdapter.parseResponse(reasoningOnly, for: deepSeekPayload()))
        let valid = try deepSeekPayload()
        let invalid = GatewayChatRequest(characterID: valid.characterID, chapterIndex: 1, chapterID: "mira_c2",
                                         chapterTitle: "Forged", storyChoices: [StoryChoiceContext(chapterID: "mira_c1", choiceID: "forged")],
                                         recentMessages: [], approvedMemories: [], message: "Continue.", imageBase64: nil)
        XCTAssertThrowsError(try DeepSeekChatAdapter.makeRequest(invalid))
    }

    func testDeepSeekRequiresNewProviderConsentBeforeNetwork() async throws {
        let suite = "TideverseTests.DeepSeekPermission.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set(true, forKey: ConsentService.enabledKey)
        defaults.set("ai-data-v1", forKey: ConsentService.versionKey)
        defaults.set(1.0, forKey: ConsentService.acceptedAtKey)
        do {
            _ = try await AIChatService.send(deepSeekPayload(), consentDefaults: defaults)
            XCTFail("Prior-provider permission must not send a DeepSeek request")
        } catch ChatServiceError.consentRequired {
            // Rejected before constructing or sending a network request.
        }
        ConsentService.accept(in: defaults)
        XCTAssertTrue(ConsentService.isGranted(in: defaults))
        XCTAssertEqual(defaults.string(forKey: ConsentService.versionKey), "deepseek-data-v2")
    }

    func testEveryCharacterUsesDeepSeekWithItsOwnPersonaAndCanonicalContext() throws {
        let catalog = ContentRepository.shared
        XCTAssertEqual(catalog.characters.count, 40)
        for character in catalog.characters {
            let story = try XCTUnwrap(catalog.story(for: character))
            for index in [0, story.chapters.count] {
                let chapter = story.chapters.indices.contains(index) ? story.chapters[index] : nil
                let choices = story.chapters.prefix(index).map {
                    StoryChoiceContext(chapterID: $0.id, choiceID: $0.choices[0].id)
                }
                let payload = GatewayChatRequest(characterID: character.id, chapterIndex: index,
                                                 chapterID: chapter?.id, chapterTitle: chapter?.title ?? "Journey completed",
                                                 storyChoices: choices, recentMessages: [],
                                                 approvedMemories: ["Take time to examine details."],
                                                 message: "Tell me about yourself.", imageBase64: nil)
                let request = try DeepSeekChatAdapter.makeRequest(payload)
                XCTAssertEqual(request.url?.host, "api.deepseek.com", character.id)
                let body = try XCTUnwrap(JSONSerialization.jsonObject(with: try XCTUnwrap(request.httpBody)) as? [String: Any])
                XCTAssertEqual(body["model"] as? String, "deepseek-flash", character.id)
                let messages = try XCTUnwrap(body["messages"] as? [[String: Any]])
                let system = try XCTUnwrap(messages.first?["content"] as? String)
                XCTAssertTrue(system.contains(character.name), character.id)
                XCTAssertTrue(system.contains(character.voice), character.id)
                XCTAssertTrue(system.contains(character.boundary), character.id)
                XCTAssertTrue(system.contains(character.goal), character.id)
                XCTAssertEqual(messages.first?["role"] as? String, "system", character.id)
                XCTAssertTrue(system.contains("these rules override the character's profession"), character.id)
                XCTAssertTrue(system.contains("can't discuss medical questions or offer medical advice"), character.id)
                XCTAssertTrue(system.contains("Please consult a qualified lawyer"), character.id)
                XCTAssertTrue(system.contains("licensed financial or tax adviser"), character.id)
                XCTAssertTrue(system.contains("Never continue an unsafe answer after adding a disclaimer"), character.id)
                let context = try XCTUnwrap(messages.dropFirst().first?["content"] as? String)
                XCTAssertTrue(context.contains(story.title), character.id)
            }
        }
    }

    func testAINetworkFailuresOfferSafeRecoveryWithoutExposingTransportDetails() {
        let secure = ChatServiceError.networkFailure(.serverCertificateUntrusted)
        guard case .secureConnectionFailed = secure else { return XCTFail("Certificate failures must stay distinct") }
        XCTAssertTrue(secure.localizedDescription.contains("Your message is saved"))
        XCTAssertFalse(secure.localizedDescription.contains("TLS"))
        let timeout = ChatServiceError.networkFailure(.timedOut)
        guard case .timedOut = timeout else { return XCTFail("Timeouts need a retry explanation") }
        let offline = ChatServiceError.networkFailure(.notConnectedToInternet)
        guard case .connectionUnavailable = offline else { return XCTFail("Offline errors need a connection explanation") }
    }

    func testMotionPolicyPreservesReducedMotionAndImmediateState() {
        XCTAssertNil(TideMotion.press(reduced: true, isPressed: true))
        XCTAssertNil(TideMotion.press(reduced: true, isPressed: false))
        XCTAssertNil(TideMotion.feedback(reduced: true))
        XCTAssertNil(TideMotion.arrival(reduced: true))
        XCTAssertNil(TideMotion.panel(reduced: true))
        XCTAssertNil(TideMotion.navigation(reduced: true))
        XCTAssertNotNil(TideMotion.press(reduced: false, isPressed: true))
        XCTAssertNotNil(TideMotion.arrival(reduced: false))
        XCTAssertNotNil(TideMotion.panel(reduced: false))
    }

    func testEULAAcceptanceIsVersionedAndDoesNotEnableAI() throws {
        let suite = "TideverseTests.EULA.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        XCTAssertFalse(UsageAgreementService.isAccepted(in: defaults))
        defaults.set("previous-version", forKey: UsageAgreementService.versionKey)
        defaults.set(1.0, forKey: UsageAgreementService.acceptedAtKey)
        XCTAssertFalse(UsageAgreementService.isAccepted(in: defaults))
        UsageAgreementService.accept(in: defaults)
        XCTAssertTrue(UsageAgreementService.isAccepted(in: defaults))
        XCTAssertFalse(ConsentService.isGranted(in: defaults))
        XCTAssertGreaterThan(defaults.double(forKey: UsageAgreementService.acceptedAtKey), 0)
    }

    func testPreparedPhotoRemovesPrivateMetadataAndKeepsPixelBound() throws {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let fixture = UIGraphicsImageRenderer(size: CGSize(width: 2200, height: 1100), format: format).image { _ in
            UIColor.white.setFill()
            UIRectFill(CGRect(x: 0, y: 0, width: 2200, height: 1100))
        }
        let raw = NSMutableData()
        let destination = try XCTUnwrap(CGImageDestinationCreateWithData(raw, UTType.jpeg.identifier as CFString, 1, nil))
        let properties: [CFString: Any] = [
            kCGImagePropertyGPSDictionary: [
                kCGImagePropertyGPSLatitude: 31.2,
                kCGImagePropertyGPSLatitudeRef: "N",
                kCGImagePropertyGPSLongitude: 121.5,
                kCGImagePropertyGPSLongitudeRef: "E"
            ],
            kCGImagePropertyExifDictionary: [kCGImagePropertyExifUserComment: "Private camera note"]
        ]
        CGImageDestinationAddImage(destination, try XCTUnwrap(fixture.cgImage), properties as CFDictionary)
        XCTAssertTrue(CGImageDestinationFinalize(destination))
        let originalSource = try XCTUnwrap(CGImageSourceCreateWithData(raw, nil))
        let original = try XCTUnwrap(CGImageSourceCopyPropertiesAtIndex(originalSource, 0, nil) as? [CFString: Any])
        XCTAssertNotNil(original[kCGImagePropertyGPSDictionary], "Fixture must contain location metadata")

        let prepared = try ImagePreparationService.prepare(imageData: raw as Data)
        let source = try XCTUnwrap(CGImageSourceCreateWithData(prepared as CFData, nil))
        let output = try XCTUnwrap(CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any])
        XCTAssertNil(output[kCGImagePropertyGPSDictionary])
        let exif = output[kCGImagePropertyExifDictionary] as? [CFString: Any]
        XCTAssertNil(exif?[kCGImagePropertyExifUserComment])
        let image = try XCTUnwrap(CGImageSourceCreateImageAtIndex(source, 0, nil))
        XCTAssertEqual(image.width, 1024)
        XCTAssertEqual(image.height, 512)
        XCTAssertLessThanOrEqual(prepared.count, 1_800_000)
        XCTAssertEqual(CGImageSourceGetType(source) as String?, UTType.jpeg.identifier)
    }

    func testUnreadableSelectedPhotoIsRejected() {
        XCTAssertThrowsError(try ImagePreparationService.prepare(imageData: Data("not an image".utf8))) { error in
            guard case ImagePreparationService.PreparationError.unreadable = error else {
                return XCTFail("Expected a readable photo error")
            }
        }
    }

    func testOnDeviceOCRReadsGeneratedEnglishText() async throws {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let fixture = UIGraphicsImageRenderer(size: CGSize(width: 1200, height: 240), format: format).pngData { _ in
            UIColor.white.setFill()
            UIRectFill(CGRect(x: 0, y: 0, width: 1200, height: 240))
            ("TIDEVERSE ARCHIVE" as NSString).draw(at: CGPoint(x: 50, y: 65), withAttributes: [
                .font: UIFont.systemFont(ofSize: 70, weight: .bold),
                .foregroundColor: UIColor.black
            ])
        }
        let text = try await VisionTextService.extractText(from: fixture)
        XCTAssertTrue(text.uppercased().contains("TIDEVERSE"))
        XCTAssertTrue(text.uppercased().contains("ARCHIVE"))
    }

    func testLongMomentPDFKeepsTextAcrossPages() throws {
        let ending = "The lantern reaches the final shore."
        let recap = String(repeating: "The archive keeps every choice safe. ", count: 500) + ending
        let moment = StoryMoment(storyID: "test", characterID: "mira", chapterID: "test",
                                 title: "A long saved moment", decision: "Keep the archive open",
                                 recap: recap, sceneAsset: "mira_scene")
        let document = try XCTUnwrap(PDFDocument(data: StoryPDFExporter.export(moment: moment)))
        XCTAssertGreaterThan(document.pageCount, 1)
        let text = try XCTUnwrap(document.string)
        XCTAssertTrue(text.contains("A long saved moment"))
        XCTAssertTrue(text.contains("Keep the archive open"))
        XCTAssertTrue(text.contains(ending), "The last paragraph must survive pagination")
        let last = try XCTUnwrap(document.page(at: document.pageCount - 1))
        let capture = XCTAttachment(image: last.thumbnail(of: CGSize(width: 612, height: 792), for: .mediaBox))
        capture.name = "paginated-pdf-last-page"
        capture.lifetime = .keepAlways
        add(capture)
    }

    func testBundledMomentPDFStaysOnOnePage() throws {
        let story = try XCTUnwrap(ContentRepository.shared.stories.first)
        let chapter = try XCTUnwrap(story.chapters.first)
        let choice = try XCTUnwrap(chapter.choices.first)
        let moment = StoryMoment(storyID: story.id, characterID: story.characterID, chapterID: chapter.id,
                                 title: chapter.title, decision: choice.label, recap: choice.outcome, sceneAsset: "mira_scene")
        let document = try XCTUnwrap(PDFDocument(data: StoryPDFExporter.export(moment: moment)))
        XCTAssertEqual(document.pageCount, 1)
        let extracted = try XCTUnwrap(document.string).split(whereSeparator: \.isWhitespace).joined(separator: " ")
        let expected = choice.outcome.split(whereSeparator: \.isWhitespace).joined(separator: " ")
        XCTAssertTrue(extracted.contains(expected))
        let first = try XCTUnwrap(document.page(at: 0))
        let capture = XCTAttachment(image: first.thumbnail(of: CGSize(width: 612, height: 792), for: .mediaBox))
        capture.name = "bundled-story-pdf"
        capture.lifetime = .keepAlways
        add(capture)
    }

    func testFortyOriginalCharactersAndStories() {
        let content = ContentRepository.shared
        XCTAssertEqual(content.characters.count, 40)
        XCTAssertEqual(content.stories.count, 40)
        XCTAssertEqual(content.stories.reduce(0) { $0 + $1.chapters.count }, 328)
        XCTAssertEqual(content.stories.reduce(0) { $0 + $1.chapters.reduce(0) { $0 + $1.choices.count } }, 656)
        XCTAssertEqual(Set(content.characters.map(\.id)).count, 40)
    }

    func testStoryChoicePersistsProgressAndMoment() throws {
        let schema = Schema([ChatRecord.self, JourneyProgress.self, StoryMoment.self, MemoryRecord.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)
        let content = ContentRepository.shared
        let story = try XCTUnwrap(content.stories.first)
        let character = try XCTUnwrap(content.character(id: story.characterID))
        let chapter = try XCTUnwrap(story.chapters.first)
        let choice = try XCTUnwrap(chapter.choices.first)
        let moment = try StoryEngine.choose(choice, in: chapter, story: story, character: character, context: context)
        XCTAssertEqual(moment.recap, choice.outcome)
        let progress = try XCTUnwrap(context.fetch(FetchDescriptor<JourneyProgress>()).first)
        XCTAssertEqual(progress.chapterIndex, 1)
        XCTAssertEqual(progress.history.count, 1)
        XCTAssertEqual(try context.fetch(FetchDescriptor<StoryMoment>()).count, 1)
    }

    func testEightNewCharactersHaveDistinctCompleteJourneys() throws {
        let ids = ["vera", "daria", "lucian", "maeve", "idris", "rhea", "bastien", "anika"]
        let content = ContentRepository.shared
        var titles = Set<String>()
        var professions = Set<String>()
        for id in ids {
            let character = try XCTUnwrap(content.character(id: id))
            let story = try XCTUnwrap(content.story(for: character))
            XCTAssertGreaterThanOrEqual(character.age, 25)
            XCTAssertGreaterThan(character.biography.count, 400)
            XCTAssertEqual(story.chapters.count, 8)
            XCTAssertTrue(titles.insert(story.title).inserted)
            XCTAssertTrue(professions.insert(character.profession).inserted)
            for chapter in story.chapters {
                XCTAssertEqual(chapter.choices.count, 2)
                XCTAssertGreaterThan(chapter.intro.count, 220)
                if chapter.number > 1 {
                    let previous = story.chapters[chapter.number - 2]
                    XCTAssertEqual(Set(chapter.echoes?.keys.map { $0 } ?? []),
                                   Set(previous.choices.map(\.id)))
                }
            }
        }
    }

    func testAllPortraitAssetsExist() throws {
        for character in ContentRepository.shared.characters {
            XCTAssertGreaterThanOrEqual(character.age, 25, character.name)
            let portrait = try XCTUnwrap(UIImage(named: character.portraitAsset)?.cgImage, character.name)
            let avatar = try XCTUnwrap(UIImage(named: character.avatarAsset)?.cgImage, character.name)
            let scene = try XCTUnwrap(UIImage(named: character.sceneAsset)?.cgImage, character.name)
            XCTAssertEqual(portrait.width, 768, character.name)
            XCTAssertEqual(portrait.height, 1024, character.name)
            XCTAssertEqual(avatar.width, 512, character.name)
            XCTAssertEqual(avatar.height, 512, character.name)
            XCTAssertEqual(scene.width, 1200, character.name)
            XCTAssertEqual(scene.height, 640, character.name)
        }
    }

    func testExpandedCatalogCompletesAndArchiveRoundTrips() throws {
        let source = try makeContainer()
        let sourceContext = ModelContext(source)
        for story in ContentRepository.shared.stories {
            let character = try XCTUnwrap(ContentRepository.shared.character(id: story.characterID))
            for chapter in story.chapters {
                try StoryEngine.choose(try XCTUnwrap(chapter.choices.last), in: chapter, story: story, character: character, context: sourceContext)
            }
        }
        let progresses = try sourceContext.fetch(FetchDescriptor<JourneyProgress>())
        XCTAssertEqual(progresses.count, 40)
        XCTAssertTrue(progresses.allSatisfy { progress in
            progress.isComplete && progress.history.count == ContentRepository.shared.story(id: progress.storyID)?.chapters.count
        })
        let data = try BackupService.export(from: sourceContext)
        let restored = try makeContainer()
        let restoredContext = ModelContext(restored)
        _ = try BackupService.importArchive(data, into: restoredContext)
        XCTAssertEqual(try restoredContext.fetchCount(FetchDescriptor<JourneyProgress>()), 40)
        XCTAssertEqual(try restoredContext.fetchCount(FetchDescriptor<StoryMoment>()), 328)
        // Importing the same archive again must be idempotent.
        _ = try BackupService.importArchive(data, into: restoredContext)
        XCTAssertEqual(try restoredContext.fetchCount(FetchDescriptor<StoryMoment>()), 328)
        let story = try XCTUnwrap(ContentRepository.shared.stories.first)
        let character = try XCTUnwrap(ContentRepository.shared.character(id: story.characterID))
        let chapter = try XCTUnwrap(story.chapters.last)
        XCTAssertThrowsError(try StoryEngine.choose(try XCTUnwrap(chapter.choices.first), in: chapter, story: story, character: character, context: restoredContext))
    }

    func testLegacyEightChapterArchiveContinuesIntoActThree() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let story = try XCTUnwrap(ContentRepository.shared.story(id: "mira_story"))
        let character = try XCTUnwrap(ContentRepository.shared.character(id: "mira"))
        for chapter in story.chapters.prefix(8) {
            _ = try StoryEngine.choose(try XCTUnwrap(chapter.choices.first), in: chapter,
                                       story: story, character: character, context: context)
        }
        let exported = try JSONDecoder().decode(TideverseArchive.self, from: BackupService.export(from: context))
        let old = try XCTUnwrap(exported.progresses.first)
        let legacy = ArchiveProgress(storyID: old.storyID, chapterIndex: 8, isComplete: true,
                                     choicesJSON: old.choicesJSON, updatedAt: old.updatedAt)
        let archive = TideverseArchive(formatVersion: 1, exportedAt: .now, messages: exported.messages,
                                       memories: exported.memories, moments: exported.moments, progresses: [legacy])
        let restoredContainer = try makeContainer()
        let restored = ModelContext(restoredContainer)
        _ = try BackupService.importArchive(JSONEncoder().encode(archive), into: restored)
        let progress = try XCTUnwrap(restored.fetch(FetchDescriptor<JourneyProgress>()).first)
        XCTAssertEqual(progress.chapterIndex, 8)
        XCTAssertEqual(progress.history.count, 8)
        XCTAssertFalse(progress.isComplete)
        let chapter = story.chapters[8]
        XCTAssertNotNil(StoryEngine.echo(for: chapter, history: progress.history))
        _ = try StoryEngine.choose(try XCTUnwrap(chapter.choices.last), in: chapter,
                                   story: story, character: character, context: restored)
        XCTAssertEqual(progress.chapterIndex, 9)
    }

    func testArchiveRejectsInconsistentCompletionBeforeMutation() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let story = try XCTUnwrap(ContentRepository.shared.stories.first)
        let badProgress = ArchiveProgress(storyID: story.id, chapterIndex: 0, isComplete: true, choicesJSON: "[]", updatedAt: .now)
        let archive = TideverseArchive(formatVersion: 1, exportedAt: .now, messages: [], memories: [], moments: [], progresses: [badProgress])
        XCTAssertThrowsError(try BackupService.importArchive(JSONEncoder().encode(archive), into: context))
        XCTAssertEqual(try context.fetchCount(FetchDescriptor<JourneyProgress>()), 0)
    }

    func testArchivePreviewValidatesWithoutChangingLocalRecords() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let message = ChatRecord(characterID: "mira", role: "user", text: "Keep this safe")
        context.insert(message)
        try context.save()
        let data = try BackupService.export(from: context)
        let preview = try BackupService.previewArchive(data)
        XCTAssertEqual(preview.messages.count, 1)
        XCTAssertEqual(preview.messages.first?.text, "Keep this safe")
        XCTAssertThrowsError(try BackupService.previewArchive(Data("not json".utf8))) { error in
            guard case BackupError.unsupportedArchive = error else {
                return XCTFail("Malformed JSON should offer an understandable archive error")
            }
        }
        XCTAssertEqual(try context.fetchCount(FetchDescriptor<ChatRecord>()), 1)
        XCTAssertEqual(message.text, "Keep this safe")
    }

    func testStoryEngineUsesCanonicalOutcome() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let story = try XCTUnwrap(ContentRepository.shared.stories.first)
        let character = try XCTUnwrap(ContentRepository.shared.character(id: story.characterID))
        let chapter = try XCTUnwrap(story.chapters.first)
        let canonical = try XCTUnwrap(chapter.choices.first)
        let forged = StoryChoice(id: canonical.id, label: "Altered label", outcome: "Altered outcome", memoryHint: "Altered hint")
        let moment = try StoryEngine.choose(forged, in: chapter, story: story, character: character, context: context)
        XCTAssertEqual(moment.decision, canonical.label)
        XCTAssertEqual(moment.recap, canonical.outcome)
    }

    func testPhotoFreeExportKeepsOriginalAttachment() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let photo = Data([1, 2, 3])
        let message = ChatRecord(characterID: "mira", role: "user", text: "A photo", imageData: photo)
        context.insert(message)
        try context.save()
        let data = try BackupService.export(from: context, includePhotos: false)
        let archive = try JSONDecoder().decode(TideverseArchive.self, from: data)
        XCTAssertEqual(archive.messages.count, 1)
        XCTAssertNil(archive.messages.first?.imageData)
        XCTAssertEqual(message.imageData, photo)
    }

    func testArchiveRestoresCanonicalProseAndScene() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let story = try XCTUnwrap(ContentRepository.shared.stories.first)
        let character = try XCTUnwrap(ContentRepository.shared.character(id: story.characterID))
        let chapter = try XCTUnwrap(story.chapters.first)
        let choice = try XCTUnwrap(chapter.choices.first)
        let entry = ChoiceHistoryEntry(id: UUID(), chapterID: chapter.id, chapterTitle: "Forged title", choiceID: choice.id, choiceLabel: "Forged choice", outcome: "Forged outcome", selectedAt: .now)
        let history = String(decoding: try JSONEncoder().encode([entry]), as: UTF8.self)
        let progress = ArchiveProgress(storyID: story.id, chapterIndex: 1, isComplete: false, choicesJSON: history, updatedAt: .now)
        let moment = ArchiveMoment(id: UUID(), storyID: story.id, characterID: character.id, chapterID: chapter.id, title: "Forged title", decision: try XCTUnwrap(chapter.choices.last).label, recap: "Forged outcome", sceneAsset: "unrelated_asset", createdAt: .now)
        let archive = TideverseArchive(formatVersion: 1, exportedAt: .now, messages: [], memories: [], moments: [moment], progresses: [progress])
        _ = try BackupService.importArchive(JSONEncoder().encode(archive), into: context)
        let restored = try XCTUnwrap(context.fetch(FetchDescriptor<StoryMoment>()).first)
        XCTAssertEqual(restored.title, chapter.title)
        XCTAssertEqual(restored.decision, choice.label)
        XCTAssertEqual(restored.recap, choice.outcome)
        XCTAssertEqual(restored.sceneAsset, character.sceneAsset)
        let restoredProgress = try XCTUnwrap(context.fetch(FetchDescriptor<JourneyProgress>()).first)
        XCTAssertEqual(restoredProgress.history.first?.outcome, choice.outcome)
    }

    func testGatewayTextBudgetPreservesEmojiClusters() {
        XCTAssertEqual(ChatTextBudget.prefix("A👨‍👩‍👧‍👦B", limit: 3), "A")
        XCTAssertEqual(ChatTextBudget.prefix("Hello", limit: 5), "Hello")
        XCTAssertEqual(ChatTextBudget.prefix("👋🏽", limit: 1), "")
    }

    func testVersionedConsentRejectsLegacyAndStalePermission() throws {
        let suite = "TideverseTests.Consent.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set(true, forKey: ConsentService.enabledKey)
        XCTAssertFalse(ConsentService.isGranted(in: defaults))
        ConsentService.accept(in: defaults)
        XCTAssertTrue(ConsentService.isGranted(in: defaults))
        defaults.set("older-notice", forKey: ConsentService.versionKey)
        XCTAssertFalse(ConsentService.isGranted(in: defaults))
        ConsentService.accept(in: defaults)
        ConsentService.revoke(in: defaults)
        XCTAssertFalse(ConsentService.isGranted(in: defaults))
        XCTAssertGreaterThan(defaults.double(forKey: ConsentService.revokedAtKey), 0)
        ConsentService.clear(in: defaults)
        XCTAssertNil(defaults.object(forKey: ConsentService.acceptedAtKey))
        XCTAssertNil(defaults.object(forKey: ConsentService.revokedAtKey))
        ConsentService.revoke(in: defaults)
        XCTAssertNil(defaults.object(forKey: ConsentService.revokedAtKey))
    }

    func testActTwoChaptersCarryActsAndBranchAwareEchoes() throws {
        let content = ContentRepository.shared
        XCTAssertEqual(content.stories.filter { $0.chapters.count == 8 }.count, 36)
        for story in content.stories {
            XCTAssertEqual(story.chapters.count, ["mira", "jonah", "elara", "rowan"].contains(story.characterID) ? 10 : 8, story.characterID)
            for chapter in story.chapters {
                if chapter.number > 4 {
                    XCTAssertEqual(chapter.act, chapter.number > 8 ? 3 : 2, chapter.id)
                    XCTAssertEqual(chapter.echoes?.count, 2, chapter.id)
                } else {
                    XCTAssertNotEqual(chapter.act, 2, chapter.id)
                }
            }
        }
        let story = try XCTUnwrap(content.story(id: "mira_story"))
        let actTwo = try XCTUnwrap(story.chapters.first { $0.id == "mira_c5" })
        let choseSeal = [historyEntry(chapter: "mira_c1", choice: "mira_c1_a")]
        let choseWatermark = [historyEntry(chapter: "mira_c1", choice: "mira_c1_b")]
        XCTAssertEqual(StoryEngine.echo(for: actTwo, history: choseSeal), actTwo.echoes?["mira_c1_a"])
        XCTAssertEqual(StoryEngine.echo(for: actTwo, history: choseWatermark), actTwo.echoes?["mira_c1_b"])
        XCTAssertNotEqual(StoryEngine.echo(for: actTwo, history: choseSeal), StoryEngine.echo(for: actTwo, history: choseWatermark))
        XCTAssertNil(StoryEngine.echo(for: story.chapters[0], history: choseSeal))
        XCTAssertNil(StoryEngine.echo(for: actTwo, history: []))
        // The latest matching decision wins when a chapter has several echoes.
        let actTwoLater = try XCTUnwrap(story.chapters.first { $0.id == "mira_c6" })
        let mixedHistory = [
            historyEntry(chapter: "mira_c1", choice: "mira_c1_a"),
            historyEntry(chapter: "mira_c3", choice: "mira_c3_b"),
            historyEntry(chapter: "mira_c4", choice: "mira_c4_a"),
        ]
        XCTAssertEqual(StoryEngine.echo(for: actTwoLater, history: mixedHistory), actTwoLater.echoes?["mira_c3_b"])
    }

    func testReopenIfExtendedLetsLegacyCompletionContinue() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let story = try XCTUnwrap(ContentRepository.shared.story(id: "mira_story"))
        let character = try XCTUnwrap(ContentRepository.shared.character(id: "mira"))
        let legacyHistory = story.chapters.prefix(4).map { historyEntry(chapter: $0.id, choice: $0.choices[0].id) }
        let encoded = try JSONEncoder().encode(legacyHistory)
        let progress = JourneyProgress(storyID: story.id, chapterIndex: 4, isComplete: true, choicesJSON: String(decoding: encoded, as: UTF8.self))
        context.insert(progress)
        try context.save()

        XCTAssertTrue(try StoryEngine.reopenIfExtended(progress, story: story, context: context))
        XCTAssertFalse(progress.isComplete)
        XCTAssertFalse(try StoryEngine.reopenIfExtended(progress, story: story, context: context))

        let next = story.chapters[4]
        XCTAssertEqual(next.id, "mira_c5")
        _ = try StoryEngine.choose(next.choices[0], in: next, story: story, character: character, context: context)
        XCTAssertEqual(progress.chapterIndex, 5)
        XCTAssertFalse(progress.isComplete)

        let inconsistent = JourneyProgress(storyID: "jonah", chapterIndex: 4, isComplete: true)
        context.insert(inconsistent)
        let jonah = try XCTUnwrap(ContentRepository.shared.story(id: "jonah_story"))
        XCTAssertFalse(try StoryEngine.reopenIfExtended(inconsistent, story: jonah, context: context))
    }

    func testStoryChatIntentMatchesAuthoredChoicesAndRejectsAmbiguity() throws {
        let story = try XCTUnwrap(ContentRepository.shared.story(id: "mira_story"))
        let chapter = try XCTUnwrap(story.chapters.first)
        let seal = StoryChatDirector.match("I want to study the wax seal under the lamp", in: chapter)
        XCTAssertEqual(seal?.choice.id, "mira_c1_a")
        let watermark = StoryChatDirector.match("Let’s read the watermark in the window", in: chapter)
        XCTAssertEqual(watermark?.choice.id, "mira_c1_b")
        XCTAssertNil(StoryChatDirector.match("I am not sure what to do. What do you think?", in: chapter))
    }

    func testStoryChatDecisionUsesCanonicalEngineAndRejectsOtherChapters() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let story = try XCTUnwrap(ContentRepository.shared.story(id: "mira_story"))
        let character = try XCTUnwrap(ContentRepository.shared.character(id: "mira"))
        let scene = try XCTUnwrap(StoryChatDirector.scene(story: story, progress: nil))
        XCTAssertEqual(scene.chapter.id, "mira_c1")
        XCTAssertNil(StoryChatDirector.validate(choiceID: "mira_c2_a", in: scene))
        XCTAssertNotNil(StoryChatDirector.validate(choiceID: "mira_c1_b", in: scene))

        let moment = try StoryChatDirector.decide(choiceID: "mira_c1_a", scene: scene, character: character, context: context)
        XCTAssertEqual(moment.decision, "Study the seal")
        XCTAssertEqual(try context.fetch(FetchDescriptor<JourneyProgress>()).first?.chapterIndex, 1)
        XCTAssertThrowsError(try StoryChatDirector.decide(choiceID: "mira_c2_a", scene: scene, character: character, context: context))
    }

    func testAuthoredChatReplyStaysLocalAndSuggestsCurrentDirection() throws {
        let story = try XCTUnwrap(ContentRepository.shared.story(id: "mira_story"))
        let character = try XCTUnwrap(ContentRepository.shared.character(id: "mira"))
        let scene = try XCTUnwrap(StoryChatDirector.scene(story: story, progress: nil))
        let reply = StoryChatDirector.authoredReply(to: "I want to read the watermark", scene: scene, character: character, userTurnCount: 1)
        XCTAssertFalse(reply.isEmpty)
        XCTAssertEqual(StoryChatDirector.match("I want to read the watermark", in: scene.chapter)?.choice.id, "mira_c1_b")
        XCTAssertNil(StoryChatDirector.scene(story: story, progress: JourneyProgress(storyID: story.id, chapterIndex: story.chapters.count, isComplete: true)))
    }

    func testArchiveRoundTripsStoryBeatMessages() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let story = try XCTUnwrap(ContentRepository.shared.story(id: "mira_story"))
        let character = try XCTUnwrap(ContentRepository.shared.character(id: "mira"))
        let choice = try XCTUnwrap(story.chapters.first?.choices.first)
        let message = ArchiveMessage(id: UUID(), characterID: character.id, role: "story",
                                     text: "Decision · \(choice.label)", imageData: nil, createdAt: .now)
        let archive = TideverseArchive(formatVersion: 1, exportedAt: .now, messages: [message],
                                       memories: [], moments: [], progresses: [])
        _ = try BackupService.importArchive(JSONEncoder().encode(archive), into: context)
        let restored = try XCTUnwrap(context.fetch(FetchDescriptor<ChatRecord>()).first)
        XCTAssertEqual(restored.role, "story")
        XCTAssertNil(restored.suggestedChoiceID)
    }

    private func historyEntry(chapter: String, choice: String) -> ChoiceHistoryEntry {
        ChoiceHistoryEntry(id: UUID(), chapterID: chapter, chapterTitle: chapter, choiceID: choice, choiceLabel: choice, outcome: choice, selectedAt: .now)
    }

    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([ChatRecord.self, JourneyProgress.self, StoryMoment.self, MemoryRecord.self])
        return try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)])
    }

}
