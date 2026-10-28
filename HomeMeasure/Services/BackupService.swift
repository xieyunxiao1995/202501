import Foundation
import SwiftData
import UniformTypeIdentifiers
import SwiftUI

struct ExportFile: FileDocument {
    static var readableContentTypes: [UTType] { [.json, .pdf] }
    static var writableContentTypes: [UTType] { [.json, .pdf] }
    var data: Data

    init(data: Data) { self.data = data }
    init(configuration: ReadConfiguration) throws {
        guard let contents = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        data = contents
    }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

enum BackupService {
    static func makeBackup(_ projects: [ProjectRecord]) throws -> ExportFile {
        let rows = try projects.map {
            BackedUpProject(id: $0.id, name: $0.name, location: $0.location,
                            createdAt: $0.createdAt, updatedAt: $0.updatedAt, details: try $0.readDetails())
        }
        let backup = ProjectBackup(format: "HomeMeasureBackup", version: 1,
                                   exportedAt: .now, projects: rows)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(backup)
        guard data.count <= 20_000_000 else { throw BackupError.exportTooLarge }
        return ExportFile(data: data)
    }

    static func restore(from url: URL, into context: ModelContext) throws -> Int {
        let granted = url.startAccessingSecurityScopedResource()
        defer { if granted { url.stopAccessingSecurityScopedResource() } }
        let size = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize
        guard let size, size <= 20_000_000 else { throw BackupError.tooLarge }
        let data = try Data(contentsOf: url)
        guard data.count <= 20_000_000 else { throw BackupError.tooLarge }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let backup = try decoder.decode(ProjectBackup.self, from: data)
        guard backup.format == "HomeMeasureBackup", backup.version == 1 else {
            throw BackupError.unsupportedFormat
        }
        guard backup.projects.allSatisfy({ valid($0) }) else { throw BackupError.invalidData }
        // Import copies, not replacements: protects existing projects from overwrites.
        do {
            for row in backup.projects {
                let new = ProjectRecord(name: row.name, location: row.location)
                var details = row.details
                // Linked room photos are intentionally not in JSON backups.
                details.rooms = details.rooms.map { var room = $0; room.photoFilename = nil; return room }
                try new.update(details)
                context.insert(new)
            }
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
        return backup.projects.count
    }
    private static func valid(_ row: BackedUpProject) -> Bool {
        let doc = row.details
        let currencies = ["USD", "EUR", "GBP", "CAD", "AUD", "JPY", "SGD", "CHF", "CNY", "HKD"]
        guard !row.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              currencies.contains(doc.currencyCode), doc.taxPercent.isFinite,
              (0...100).contains(doc.taxPercent), doc.shipping.isFinite, doc.shipping >= 0, doc.shipping <= 1_000_000_000,
              Set(doc.rooms.map(\.id)).count == doc.rooms.count,
              Set(doc.materials.map(\.id)).count == doc.materials.count else { return false }
        let roomIDs = Set(doc.rooms.map(\.id))
        return doc.rooms.allSatisfy { room in
            !room.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            [room.length, room.width, room.height].allSatisfy { $0.isFinite && $0 > 0 && $0 <= 1000 } &&
            Set(room.openings.map(\.id)).count == room.openings.count &&
            room.openings.allSatisfy { $0.width.isFinite && $0.height.isFinite &&
                $0.width > 0 && $0.width <= 1000 && $0.height > 0 && $0.height <= 1000 && (1...30).contains($0.count) }
        } && doc.materials.allSatisfy { item in
            roomIDs.contains(item.roomID) && !item.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !item.packUnit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            [item.coveragePerPack, item.unitPrice, item.wastePercent, item.manualQuantity].allSatisfy(\.isFinite) &&
            item.coveragePerPack > 0 && item.coveragePerPack <= 1_000_000 &&
            item.unitPrice >= 0 && item.unitPrice <= 1_000_000_000 &&
            (0...100).contains(item.wastePercent) && (1...10).contains(item.coats) &&
            item.manualQuantity >= 0 && item.manualQuantity <= 1_000_000_000 &&
            item.overridePacks.map { (0...1_000_000).contains($0) } != false
        }
    }
}

enum BackupError: LocalizedError {
    case tooLarge, exportTooLarge, unsupportedFormat, invalidData
    var errorDescription: String? {
        switch self {
        case .tooLarge: "The selected backup exceeds 20 MB."
        case .exportTooLarge: "The backup exceeds the 20 MB import limit. Reduce project notes before trying again."
        case .unsupportedFormat: "This file is not a supported HomeMeasure backup."
        case .invalidData: "The backup contains invalid project data and was not imported."
        }
    }
}
