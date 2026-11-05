import Foundation

/// World space uses metres: origin at upper left, +X right, +Y down.
/// `northDegrees` is clockwise rotation of true north from the screen's upward direction.
enum SceneKind: String, Codable, CaseIterable, Identifiable, Sendable {
    case garden = "Garden"
    case patio = "Patio"
    case balcony = "Balcony"
    case photography = "Photography"
    case custom = "Custom"
    var id: String { rawValue }
}

enum ElementKind: String, Codable, CaseIterable, Identifiable, Sendable {
    case building = "Building"
    case wall = "Wall"
    case column = "Column"
    case tree = "Tree"
    case fence = "Fence"
    case canopy = "Solid Canopy"
    case rectangle = "Custom Rectangle"
    var id: String { rawValue }
    var symbol: String {
        switch self {
        case .building: return "building.2.fill"
        case .wall: return "square.split.1x2.fill"
        case .column: return "circle.fill"
        case .tree: return "tree.fill"
        case .fence: return "line.3.horizontal"
        case .canopy: return "rectangle.topthird.inset.filled"
        case .rectangle: return "rectangle.fill"
        }
    }
}

enum TargetKind: String, Codable, CaseIterable, Identifiable, Sendable {
    case observation = "Observation Point"
    case vegetable = "Vegetable Bed"
    case flowers = "Flower Bed"
    case herbs = "Herb Garden"
    case seating = "Seating Area"
    case custom = "Custom Area"
    var id: String { rawValue }
}

struct SceneElement: Codable, Identifiable, Equatable, Sendable {
    var id: UUID = UUID()
    var name: String
    var kind: ElementKind
    var x: Double
    var y: Double
    var width: Double
    var depth: Double
    var height: Double
    var rotation: Double = 0
    var crownDiameter: Double = 2.5
    var crownBaseHeight: Double = 1.8
    var isLocked: Bool = false
    var isHidden: Bool = false

    static func make(_ kind: ElementKind, in scene: SceneDocument) -> SceneElement {
        let count = scene.elements.filter { $0.kind == kind }.count + 1
        return SceneElement(name: "\(kind.rawValue) \(count)", kind: kind,
                            x: scene.width * 0.5, y: scene.height * 0.5,
                            width: kind == .wall || kind == .fence ? 5 : 2.5,
                            depth: kind == .wall || kind == .fence ? 0.22 : 2,
                            height: kind == .tree ? 4 : 2.4)
    }
}

struct ObservationTarget: Codable, Identifiable, Equatable, Sendable {
    var id: UUID = UUID()
    var name: String
    var kind: TargetKind
    var x: Double
    var y: Double
    var width: Double
    var depth: Double
    var targetHours: Double = 6
    var notes: String = ""
    var isPoint: Bool { kind == .observation }
}

struct SceneDocument: Codable, Identifiable, Equatable, Sendable {
    var schemaVersion: Int = 1
    var id: UUID = UUID()
    var name: String
    var kind: SceneKind
    var latitude: Double
    var longitude: Double
    var timeZoneID: String
    var width: Double
    var height: Double
    var northDegrees: Double = 0
    var notes: String = ""
    var elements: [SceneElement] = []
    var targets: [ObservationTarget] = []

    var timeZone: TimeZone { TimeZone(identifier: timeZoneID) ?? .gmt }
    var isValid: Bool {
        let siteValid = latitude.isFinite && longitude.isFinite && width.isFinite
            && height.isFinite && northDegrees.isFinite
            && (-90...90).contains(latitude) && (-180...180).contains(longitude)
            && (1...2000).contains(width) && (1...2000).contains(height)
            && TimeZone(identifier: timeZoneID) != nil
        let objectsValid = elements.allSatisfy { item in
            [item.x, item.y, item.width, item.depth, item.height,
             item.rotation, item.crownDiameter, item.crownBaseHeight].allSatisfy(\.isFinite)
            && item.width > 0 && item.depth > 0 && item.height >= 0
            && item.crownDiameter > 0 && item.crownBaseHeight >= 0
            && abs(item.x) < 100_000 && abs(item.y) < 100_000
        }
        let targetsValid = targets.allSatisfy { item in
            [item.x, item.y, item.width, item.depth, item.targetHours].allSatisfy(\.isFinite)
            && item.width >= 0 && item.depth >= 0 && (0...24).contains(item.targetHours)
            && abs(item.x) < 100_000 && abs(item.y) < 100_000
        }
        return siteValid && objectsValid && targetsValid
    }
    var activeElements: [SceneElement] { elements.filter { !$0.isHidden } }

    func copyAs(_ newName: String) -> SceneDocument {
        var copied = self
        copied.id = UUID()
        copied.name = newName
        copied.elements = elements.map { var e = $0; e.id = UUID(); return e }
        copied.targets = targets.map { var t = $0; t.id = UUID(); return t }
        return copied
    }

    static func blank() -> SceneDocument {
        SceneDocument(name: "New Outdoor Space", kind: .garden,
                      latitude: 51.5074, longitude: -0.1278, timeZoneID: "Europe/London",
                      width: 18, height: 14)
    }
}
