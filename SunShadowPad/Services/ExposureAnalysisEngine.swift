import Foundation

enum ExposureAnalysisEngine {
    static func calculate(scene: SceneDocument, day: Date,
                          targetID: UUID? = nil, stepMinutes: Int = 10,
                          columns: Int = 18) -> ExposureResult {
        let interval = TimeService.intervalOfDay(day, in: scene.timeZoneID)
        let step = max(5, min(60, stepMinutes))
        let cols = max(8, min(32, columns))
        let rows = max(6, min(32, Int((Double(cols) * scene.height / scene.width).rounded())))
        let dx = scene.width / Double(cols), dy = scene.height / Double(rows)
        var heatHours = Array(repeating: 0.0, count: cols * rows)
        let targetPoints: [[Point2]] = scene.targets.map { target in
            if target.isPoint { return [Point2(x: target.x, y: target.y)] }
            return [-0.4, 0, 0.4].flatMap { fx in
                [-0.4, 0, 0.4].map { fy in
                    Point2(x: target.x + fx * target.width, y: target.y + fy * target.depth)
                }
            }
        }
        var targetTotals = Array(repeating: 0.0, count: scene.targets.count)
        var blockedTotals = Array(repeating: 0.0, count: scene.targets.count)
        var firstSun: [Date?] = Array(repeating: nil, count: scene.targets.count)
        var lastSun: [Date?] = Array(repeating: nil, count: scene.targets.count)
        var currentRuns = Array(repeating: 0.0, count: scene.targets.count)
        var longestRuns = Array(repeating: 0.0, count: scene.targets.count)
        var samples: [ExposureSample] = []
        var maxHours = 0.0
        let chosenIndex = scene.targets.firstIndex(where: { $0.id == targetID })
        var t = interval.start
        while t < interval.end {
            let dt = min(Double(step) * 60, interval.end.timeIntervalSince(t)) / 3600
            let sun = SolarPositionEngine.position(at: t.addingTimeInterval(dt * 1800),
                                                   latitude: scene.latitude, longitude: scene.longitude,
                                                   timeZoneID: scene.timeZoneID)
            let lit = sun.isAboveHorizon
            let polygons = lit ? ShadowGeometryEngine.shadowPolygons(for: scene, at: sun) : []
            var litGridCount = 0
            if lit {
                maxHours += dt
                for i in 0..<heatHours.count {
                    let p = Point2(x: (Double(i % cols) + 0.5) * dx,
                                   y: (Double(i / cols) + 0.5) * dy)
                    if !ShadowGeometryEngine.isShaded(p, polygons: polygons) {
                        heatHours[i] += dt
                        litGridCount += 1
                    }
                }
            }
            var targetMajority = Array(repeating: false, count: targetPoints.count)
            for (i, points) in targetPoints.enumerated() {
                let bright = lit ? Double(points.filter { !ShadowGeometryEngine.isShaded($0, polygons: polygons) }.count)
                                     / Double(points.count) : 0
                targetTotals[i] += bright * dt
                if lit { blockedTotals[i] += (1 - bright) * dt }
                targetMajority[i] = bright >= 0.5
                if targetMajority[i] {
                    if firstSun[i] == nil { firstSun[i] = t }
                    lastSun[i] = t.addingTimeInterval(dt * 3600)
                    currentRuns[i] += dt
                    longestRuns[i] = max(longestRuns[i], currentRuns[i])
                } else {
                    currentRuns[i] = 0
                }
            }
            // For a region, the timeline bar uses majority-lit status; the numeric hours
            // remain the space-weighted average. With no selected target, the bar represents
            // a majority of heatmap cells, not any arbitrary first observation target.
            let majoritySunny = chosenIndex.map { targetMajority[$0] }
                ?? (lit && litGridCount * 2 >= heatHours.count)
            samples.append(ExposureSample(time: t, sunny: majoritySunny,
                                          isDay: lit, blockers: []))
            t = t.addingTimeInterval(dt * 3600)
        }
        let targets: [TargetExposure] = scene.targets.enumerated().map { i, target in
            TargetExposure(targetID: target.id, name: target.name,
                           sunnyHours: targetTotals[i], blockedHours: blockedTotals[i],
                           firstSun: firstSun[i], lastSun: lastSun[i],
                           longestSunnyHours: longestRuns[i], targetHours: target.targetHours)
        }
        let cells: [HeatCell] = heatHours.enumerated().map { index, hours in
            let row = index / cols, col = index % cols
            return HeatCell(row: row, col: col, totalCols: cols,
                            x: Double(col) * dx, y: Double(row) * dy,
                            width: dx, height: dy, sunnyHours: hours)
        }
        return ExposureResult(day: day, stepMinutes: step,
                              events: SolarPositionEngine.events(on: day, in: scene),
                              samples: samples, targets: targets, heat: cells,
                              maxSunHours: maxHours, cols: cols, rows: rows)
    }

    static func monthlyHours(scene: SceneDocument, year: Int, target: ObservationTarget?,
                             stepMinutes: Int = 15) -> [(month: Int, hours: Double)] {
        let cal = TimeService.calendar(scene.timeZoneID)
        return (1...12).map { month in
            var c = DateComponents()
            c.year = year; c.month = month; c.day = 15; c.hour = 12
            c.timeZone = scene.timeZone
            let day = cal.date(from: c) ?? Date()
            return (month, hoursAtPoint(scene: scene, day: day, target: target,
                                        stepMinutes: stepMinutes))
        }
    }

    /// Representative days near each equinox and solstice. Dates are approximate
    /// calendar markers, not astronomical event times.
    static func seasonalHours(scene: SceneDocument, year: Int, target: ObservationTarget?,
                              stepMinutes: Int = 15) -> [(name: String, date: Date, hours: Double)] {
        let cal = TimeService.calendar(scene.timeZoneID)
        let markers = [("Spring Equinox", 3, 20), ("Summer Solstice", 6, 21),
                       ("Autumn Equinox", 9, 22), ("Winter Solstice", 12, 21)]
        return markers.map { name, month, dayOfMonth in
            var c = DateComponents()
            c.year = year; c.month = month; c.day = dayOfMonth; c.hour = 12
            c.timeZone = scene.timeZone
            let day = cal.date(from: c) ?? Date()
            return (name, day, hoursAtPoint(scene: scene, day: day, target: target,
                                            stepMinutes: stepMinutes))
        }
    }

    private static func hoursAtPoint(scene: SceneDocument, day: Date, target: ObservationTarget?,
                                     stepMinutes: Int) -> Double {
        let interval = TimeService.intervalOfDay(day, in: scene.timeZoneID)
        let point = Point2(x: target?.x ?? scene.width / 2, y: target?.y ?? scene.height / 2)
        var hours = 0.0
        var t = interval.start
        while t < interval.end {
            let dt = min(Double(stepMinutes) * 60, interval.end.timeIntervalSince(t))
            let sun = SolarPositionEngine.position(at: t.addingTimeInterval(dt / 2),
                                                   latitude: scene.latitude, longitude: scene.longitude,
                                                   timeZoneID: scene.timeZoneID)
            if sun.isAboveHorizon && !ShadowGeometryEngine.isShaded(
                point, polygons: ShadowGeometryEngine.shadowPolygons(for: scene, at: sun)) {
                hours += dt / 3600
            }
            t = t.addingTimeInterval(dt)
        }
        return hours
    }
}
