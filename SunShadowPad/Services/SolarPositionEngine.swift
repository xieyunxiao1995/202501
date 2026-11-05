import Foundation

/// NOAA Global Monitoring Division approximate solar-position equations.
/// Suitable for illustrative geometry, not astronomical certification.
enum SolarPositionEngine {
    private static let deg = Double.pi / 180
    private static func radians(_ d: Double) -> Double { d * deg }
    private static func degrees(_ r: Double) -> Double { r / deg }
    private static func clamp(_ value: Double, _ a: Double, _ b: Double) -> Double { min(b, max(a, value)) }

    static func position(at date: Date, latitude: Double, longitude: Double, timeZoneID: String) -> SunPosition {
        let cal = TimeService.calendar(timeZoneID)
        let c = cal.dateComponents([.year, .day, .hour, .minute, .second], from: date)
        let ordinal = cal.ordinality(of: .day, in: .year, for: date) ?? 1
        let year = c.year ?? 2026
        let daysInYear = cal.range(of: .day, in: .year, for: date)?.count ?? (cal.isDateInLeapYear(date) ? 366 : 365)
        let localHours = Double(c.hour ?? 12) + Double(c.minute ?? 0) / 60 + Double(c.second ?? 0) / 3600
        let gamma = 2 * Double.pi / Double(daysInYear) * (Double(ordinal - 1) + (localHours - 12) / 24)
        let equation = 229.18 * (0.000075 + 0.001868 * cos(gamma) - 0.032077 * sin(gamma)
                                  - 0.014615 * cos(2 * gamma) - 0.040849 * sin(2 * gamma))
        let decl = 0.006918 - 0.399912 * cos(gamma) + 0.070257 * sin(gamma)
                   - 0.006758 * cos(2 * gamma) + 0.000907 * sin(2 * gamma)
                   - 0.002697 * cos(3 * gamma) + 0.00148 * sin(3 * gamma)
        let tzHours = Double(cal.timeZone.secondsFromGMT(for: date)) / 3600
        let trueSolarMinutes = localHours * 60 + equation + 4 * longitude - 60 * tzHours
        let hourAngle = radians((trueSolarMinutes / 4 - 180).truncatingRemainder(dividingBy: 360))
        let latitudeR = radians(clamp(latitude, -90, 90))
        let cosZenith = clamp(sin(latitudeR) * sin(decl) + cos(latitudeR) * cos(decl) * cos(hourAngle), -1, 1)
        let zenith = acos(cosZenith)
        let elevation = 90 - degrees(zenith)
        // atan2 yields clockwise azimuth measured from true north.
        let azimuth = (degrees(atan2(sin(hourAngle), cos(hourAngle) * sin(latitudeR)
                                      - tan(decl) * cos(latitudeR))) + 180 + 360)
            .truncatingRemainder(dividingBy: 360)
        _ = year // Gregorian year intentionally derived for valid local components.
        return SunPosition(elevation: elevation, azimuth: azimuth, equationOfTime: equation)
    }

    static func events(on day: Date, in scene: SceneDocument) -> SunEventTimes {
        let interval = TimeService.intervalOfDay(day, in: scene.timeZoneID)
        let advance: TimeInterval = 300
        var previous = interval.start
        var previousAbove = position(at: previous, latitude: scene.latitude,
                                     longitude: scene.longitude, timeZoneID: scene.timeZoneID).isAboveHorizon
        var sunrise: Date?
        var sunset: Date?
        var sawAbove = previousAbove
        var sawBelow = !previousAbove
        var bestNoon = previous
        var bestElevation = -Double.infinity
        var instant = interval.start
        while instant <= interval.end {
            let sun = position(at: instant, latitude: scene.latitude,
                               longitude: scene.longitude, timeZoneID: scene.timeZoneID)
            if sun.elevation > bestElevation { bestElevation = sun.elevation; bestNoon = instant }
            if sun.isAboveHorizon { sawAbove = true } else { sawBelow = true }
            if previousAbove != sun.isAboveHorizon {
                var low = previous, high = instant
                for _ in 0..<10 {
                    let middle = low.addingTimeInterval(high.timeIntervalSince(low) / 2)
                    let lit = position(at: middle, latitude: scene.latitude,
                                       longitude: scene.longitude, timeZoneID: scene.timeZoneID).isAboveHorizon
                    if lit == previousAbove { low = middle } else { high = middle }
                }
                if sun.isAboveHorizon { sunrise = high } else { sunset = high }
            }
            previous = instant
            previousAbove = sun.isAboveHorizon
            instant = instant.addingTimeInterval(advance)
        }
        return SunEventTimes(sunrise: sunrise, solarNoon: bestNoon, sunset: sunset,
                             alwaysAbove: sawAbove && !sawBelow,
                             alwaysBelow: sawBelow && !sawAbove)
    }
}

private extension Calendar {
    func isDateInLeapYear(_ date: Date) -> Bool {
        let year = component(.year, from: date)
        return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
    }
}
