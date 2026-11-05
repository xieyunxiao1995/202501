import Foundation

struct Point2: Codable, Equatable, Sendable {
    var x: Double
    var y: Double
    static func + (lhs: Point2, rhs: Point2) -> Point2 { .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y) }
}

struct Polygon2: Sendable {
    var points: [Point2]
}

struct SunPosition: Sendable {
    let elevation: Double   // degrees above astronomical horizon
    let azimuth: Double     // degrees clockwise from true north
    let equationOfTime: Double
    var isAboveHorizon: Bool { elevation > 0 }
}

struct SunEventTimes: Sendable {
    var sunrise: Date?
    var solarNoon: Date?
    var sunset: Date?
    var alwaysAbove: Bool = false
    var alwaysBelow: Bool = false
}

struct ExposureSample: Identifiable, Sendable {
    var id: Date { time }
    let time: Date
    let sunny: Bool
    let isDay: Bool
    let blockers: [String]
}

struct TargetExposure: Identifiable, Sendable {
    var id: UUID { targetID }
    let targetID: UUID
    let name: String
    let sunnyHours: Double
    let blockedHours: Double
    let firstSun: Date?
    let lastSun: Date?
    let longestSunnyHours: Double
    let targetHours: Double
    var meetsTarget: Bool { sunnyHours >= targetHours }
}

struct HeatCell: Identifiable, Sendable {
    var id: Int { row * totalCols + col }
    let row: Int
    let col: Int
    let totalCols: Int
    let x: Double
    let y: Double
    let width: Double
    let height: Double
    let sunnyHours: Double
}

struct ExposureResult: Sendable {
    let day: Date
    let stepMinutes: Int
    let events: SunEventTimes
    let samples: [ExposureSample]
    let targets: [TargetExposure]
    let heat: [HeatCell]
    let maxSunHours: Double
    let cols: Int
    let rows: Int
    var totalBrightCells: Int { heat.filter { $0.sunnyHours >= 6 }.count }
}
