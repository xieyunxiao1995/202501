import Foundation

enum SceneSamples {
    static var all: [SceneDocument] { [courtyard, balcony, photography] }

    static var courtyard: SceneDocument {
        var scene = SceneDocument(name: "Courtyard Garden", kind: .garden,
                                  latitude: 51.5074, longitude: -0.1278,
                                  timeZoneID: "Europe/London", width: 20, height: 15,
                                  northDegrees: 0, notes: "A walled London courtyard with two planting beds.")
        scene.elements = [
            SceneElement(name: "West Boundary", kind: .wall, x: 1.1, y: 7.5, width: 0.3, depth: 13, height: 2.2),
            SceneElement(name: "North Wall", kind: .wall, x: 10, y: 1, width: 18, depth: 0.3, height: 2),
            SceneElement(name: "Garden Studio", kind: .building, x: 15.7, y: 4.2, width: 5.2, depth: 4, height: 3.2),
            SceneElement(name: "Ornamental Maple", kind: .tree, x: 5.0, y: 6.4, width: 2.6, depth: 2.6, height: 4.4,
                         crownDiameter: 3.8, crownBaseHeight: 1.9)
        ]
        scene.targets = [
            ObservationTarget(name: "Vegetable Plot", kind: .vegetable, x: 12, y: 10.5, width: 3.2, depth: 2.6, targetHours: 6),
            ObservationTarget(name: "Herb Corner", kind: .herbs, x: 5, y: 11, width: 2.5, depth: 2, targetHours: 5),
            ObservationTarget(name: "Patio Chair", kind: .observation, x: 9, y: 7.5, width: 0, depth: 0, targetHours: 4)
        ]
        return scene
    }

    static var balcony: SceneDocument {
        var scene = SceneDocument(name: "Balcony Planning", kind: .balcony,
                                  latitude: 40.7128, longitude: -74.0060,
                                  timeZoneID: "America/New_York", width: 8, height: 4,
                                  northDegrees: 85, notes: "An east-facing apartment balcony.")
        scene.elements = [
            SceneElement(name: "Side Partition", kind: .wall, x: 0.35, y: 2, width: 0.3, depth: 4, height: 2.3),
            SceneElement(name: "Overhead Canopy", kind: .canopy, x: 4.4, y: 0.8, width: 4.2, depth: 1.5, height: 2.6)
        ]
        scene.targets = [ObservationTarget(name: "Planter", kind: .vegetable,
                                           x: 4.4, y: 2.6, width: 3.0, depth: 0.8, targetHours: 5)]
        return scene
    }

    static var photography: SceneDocument {
        var scene = SceneDocument(name: "Outdoor Photo Setup", kind: .photography,
                                  latitude: 34.0522, longitude: -118.2437,
                                  timeZoneID: "America/Los_Angeles", width: 28, height: 18,
                                  northDegrees: 24, notes: "A courtyard location with a photographer's observation point.")
        scene.elements = [
            SceneElement(name: "Warehouse", kind: .building, x: 5, y: 5, width: 6, depth: 7, height: 5),
            SceneElement(name: "Courtyard Tree", kind: .tree, x: 19, y: 7, width: 3, depth: 3,
                         height: 5, crownDiameter: 4, crownBaseHeight: 2.5),
            SceneElement(name: "South Fence", kind: .fence, x: 14, y: 17, width: 26, depth: 0.2, height: 1.8)
        ]
        scene.targets = [
            ObservationTarget(name: "Camera Position", kind: .observation, x: 15, y: 10, width: 0, depth: 0, targetHours: 5),
            ObservationTarget(name: "Portrait Zone", kind: .custom, x: 18, y: 12.5, width: 5, depth: 3, targetHours: 4)
        ]
        return scene
    }
}
