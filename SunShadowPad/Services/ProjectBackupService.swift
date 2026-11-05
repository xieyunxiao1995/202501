import Foundation
import SwiftData
import SwiftUI
import UniformTypeIdentifiers

struct LocalProjectArchive: Codable {
    var app: String = "SunShadowPad"
    var formatVersion: Int = 1
    var exportedAt: Date = Date()
    var scenes: [SceneDocument]
}

struct ExportFileDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json, .pdf, .png] }
    static var writableContentTypes: [UTType] { [.json, .pdf, .png] }
    var bytes: Data
    init(bytes: Data) { self.bytes = bytes }
    init(configuration: ReadConfiguration) throws {
        bytes = configuration.file.regularFileContents ?? Data()
    }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: bytes)
    }
}

enum ProjectBackupService {
    static func json(for scene: SceneDocument) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(scene)
    }
    static func exportAll(_ records: [StoredScene]) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(LocalProjectArchive(scenes: records.map(\.document)))
    }
    static func importScenes(_ data: Data) throws -> [SceneDocument] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let archive = try? decoder.decode(LocalProjectArchive.self, from: data) {
            guard archive.formatVersion == 1 && archive.app == "SunShadowPad" else {
                throw BackupError.unsupportedFormat
            }
            guard archive.scenes.allSatisfy(\.isValid) else { throw BackupError.invalidCoordinates }
            return archive.scenes
        }
        let scene = try JSONDecoder().decode(SceneDocument.self, from: data)
        guard scene.isValid else { throw BackupError.invalidCoordinates }
        return [scene]
    }

    static func insertImported(_ imported: [SceneDocument], into context: ModelContext,
                               existing: [StoredScene]) throws -> Int {
        guard imported.count <= 500 else { throw BackupError.excessiveScenes }
        var knownIDs = Set(existing.map(\.id))
        for var scene in imported {
            if knownIDs.contains(scene.id) { scene = scene.copyAs(scene.name + " (Imported)") }
            while knownIDs.contains(scene.id) { scene.id = UUID() }
            knownIDs.insert(scene.id)
            context.insert(StoredScene(document: scene))
        }
        try context.save()
        return imported.count
    }

    enum BackupError: LocalizedError {
        case unsupportedFormat, invalidCoordinates, excessiveScenes
        var errorDescription: String? {
            switch self {
            case .unsupportedFormat: return "Unsupported project archive version."
            case .invalidCoordinates: return "Scene location, timezone or dimensions are invalid."
            case .excessiveScenes: return "An archive may contain at most 500 scenes."
            }
        }
    }
}
