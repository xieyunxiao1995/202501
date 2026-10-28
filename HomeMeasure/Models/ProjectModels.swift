import Foundation
import SwiftData

// A SwiftData project is the transactional root. Its rooms and shopping lines
// are an encoded value snapshot, so changes are saved as one consistent edit.
@Model
final class ProjectRecord {
    @Attribute(.unique) var id: UUID
    var name: String
    var location: String
    var createdAt: Date
    var updatedAt: Date
    @Attribute(.externalStorage) var content: Data

    init(name: String, location: String = "") {
        self.id = UUID()
        self.name = name
        self.location = location
        self.createdAt = .now
        self.updatedAt = .now
        self.content = (try? JSONEncoder().encode(ProjectContent())) ?? Data()
    }

    func requireAvailable(in context: ModelContext) throws {
        guard modelContext === context && !isDeleted else { throw ProjectContentError.deleted }
    }

    func readDetails() throws -> ProjectContent {
        do { return try JSONDecoder().decode(ProjectContent.self, from: content) }
        catch { throw ProjectContentError.unreadable }
    }

    var isContentReadable: Bool { (try? readDetails()) != nil }
    // Display-only fallback. All mutations and exports must use readDetails().
    var details: ProjectContent { (try? readDetails()) ?? ProjectContent() }

    func update(_ newValue: ProjectContent) throws {
        _ = try readDetails()
        content = try JSONEncoder().encode(newValue)
        updatedAt = .now
    }
}

enum ProjectContentError: LocalizedError {
    case unreadable, deleted
    var errorDescription: String? {
        switch self {
        case .unreadable: "This project's data could not be read. It has not been changed. Restore a previous backup if available."
        case .deleted: "This project has been deleted. Close this screen and create or open another project."
        }
    }
}

struct ProjectContent: Codable {
    var rooms: [RoomPlan] = []
    var materials: [MaterialPlan] = []
    var taxPercent: Double = 0
    var shipping: Double = 0
    var currencyCode: String = "USD"
    var notes: String = ""
}

struct RoomPlan: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var length: Double
    var width: Double
    var height: Double
    var openings: [RoomOpening] = []
    var photoFilename: String? = nil
    var notes: String = ""
}

enum OpeningType: String, Codable, CaseIterable, Identifiable {
    case door = "Door"
    case window = "Window"
    var id: String { rawValue }
}

struct RoomOpening: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var kind: OpeningType = .door
    var width: Double = 0.9
    var height: Double = 2.1
    var count: Int = 1
}

enum MaterialCategory: String, Codable, CaseIterable, Identifiable {
    case tile = "Tile"
    case flooring = "Flooring"
    case paint = "Paint"
    case wallpaper = "Wallpaper"
    case baseboard = "Baseboard"
    case other = "Other"
    var id: String { rawValue }
    var symbol: String {
        switch self {
        case .tile: "square.grid.3x3"
        case .flooring: "square.stack.3d.up"
        case .paint: "paintbrush.pointed"
        case .wallpaper: "rectangle.portrait.on.rectangle.portrait"
        case .baseboard: "ruler"
        case .other: "shippingbox"
        }
    }
}

enum MaterialSurface: String, Codable, CaseIterable, Identifiable {
    case floor = "Floor"
    case walls = "Walls"
    case ceiling = "Ceiling"
    case perimeter = "Baseboard length"
    case manual = "Manual quantity"
    var id: String { rawValue }
    var unit: String { self == .perimeter ? "m" : (self == .manual ? "units" : "m²") }
}

struct MaterialPlan: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var roomID: UUID
    var name: String
    var category: MaterialCategory
    var surface: MaterialSurface
    var coveragePerPack: Double
    var packUnit: String
    var unitPrice: Double
    var wastePercent: Double
    var coats: Int
    var manualQuantity: Double
    var overridePacks: Int? = nil
    var purchased: Bool = false
    var notes: String = ""
}

struct ProjectBackup: Codable {
    let format: String
    let version: Int
    let exportedAt: Date
    let projects: [BackedUpProject]
}

struct BackedUpProject: Codable {
    let id: UUID
    let name: String
    let location: String
    let createdAt: Date
    let updatedAt: Date
    let details: ProjectContent
}
