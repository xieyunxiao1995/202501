import Foundation

struct ScenarioDifference: Sendable {
    let a: ExposureResult
    let b: ExposureResult
    let baseHours: Double
    let changedHours: Double
    var difference: Double { changedHours - baseHours }
}

enum ScenarioComparisonService {
    static func sameSite(_ a: SceneDocument, _ b: SceneDocument) -> Bool {
        abs(a.latitude - b.latitude) < 0.00001 && abs(a.longitude - b.longitude) < 0.00001
        && a.timeZoneID == b.timeZoneID && abs(a.width - b.width) < 0.001
        && abs(a.height - b.height) < 0.001 && abs(a.northDegrees - b.northDegrees) < 0.001
    }

    static func compare(_ a: SceneDocument, _ b: SceneDocument, day: Date,
                        targetID: UUID?) -> ScenarioDifference {
        let ar = ExposureAnalysisEngine.calculate(scene: a, day: day, targetID: targetID)
        let br = ExposureAnalysisEngine.calculate(scene: b, day: day,
                                                  targetID: b.targets.first(where: {
                $0.name == a.targets.first(where: { $0.id == targetID })?.name
            })?.id)
        let targetName = a.targets.first(where: { $0.id == targetID })?.name
        let aHours = ar.targets.first(where: { $0.name == targetName })?.sunnyHours
            ?? ar.heat.reduce(0) { $0 + $1.sunnyHours } / Double(max(ar.heat.count, 1))
        let bHours = br.targets.first(where: { $0.name == targetName })?.sunnyHours
            ?? br.heat.reduce(0) { $0 + $1.sunnyHours } / Double(max(br.heat.count, 1))
        return ScenarioDifference(a: ar, b: br, baseHours: aHours, changedHours: bHours)
    }
}
