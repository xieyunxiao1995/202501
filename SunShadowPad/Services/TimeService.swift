import Foundation

enum TimeService {
    static func calendar(_ timeZoneID: String) -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: timeZoneID) ?? .gmt
        return calendar
    }

    static func intervalOfDay(_ day: Date, in timeZoneID: String) -> DateInterval {
        let calendar = calendar(timeZoneID)
        return calendar.dateInterval(of: .day, for: day) ?? DateInterval(start: day, duration: 86400)
    }

    static func localInstant(on day: Date, minutes: Int, in timeZoneID: String) -> Date {
        let calendar = calendar(timeZoneID)
        let components = calendar.dateComponents([.year, .month, .day], from: day)
        var target = DateComponents()
        target.timeZone = calendar.timeZone
        target.year = components.year
        target.month = components.month
        target.day = components.day
        target.hour = max(0, min(23, minutes / 60))
        target.minute = max(0, min(59, minutes % 60))
        // A non-existent local time during a DST spring-forward transition is normalized by Calendar.
        return calendar.date(from: target) ?? day
    }

    static func clock(_ date: Date?, timeZoneID: String, is24Hour: Bool = true) -> String {
        guard let date else { return "—" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: timeZoneID) ?? .gmt
        formatter.dateFormat = is24Hour ? "HH:mm" : "h:mm a"
        return formatter.string(from: date)
    }

    static func dayLabel(_ date: Date, timeZoneID: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: timeZoneID) ?? .gmt
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
