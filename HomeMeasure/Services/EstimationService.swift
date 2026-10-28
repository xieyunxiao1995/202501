import Foundation

struct RoomMeasures {
    let floor: Double
    let wallGross: Double
    let openings: Double
    let wallNet: Double
    let ceiling: Double
    let perimeter: Double
    let baseboardLength: Double
}

struct MaterialEstimate: Identifiable {
    let material: MaterialPlan
    let roomName: String
    let baseQuantity: Double
    let requiredQuantity: Double
    let packs: Int
    let cost: Decimal
    let quantityExceedsLimit: Bool
    var id: UUID { material.id }
}

struct BudgetSummary {
    let subtotal: Decimal
    let tax: Decimal
    let shipping: Decimal
    let total: Decimal
}

enum EstimationService {
    static func room(_ room: RoomPlan) -> RoomMeasures {
        let floor = room.length * room.width
        let gross = 2 * (room.length + room.width) * room.height
        let openings = room.openings.reduce(0.0) { $0 + $1.width * $1.height * Double($1.count) }
        let doors = room.openings.filter { $0.kind == .door }
            .reduce(0.0) { $0 + $1.width * Double($1.count) }
        let perimeter = 2 * (room.length + room.width)
        return RoomMeasures(floor: floor, wallGross: gross, openings: openings,
                            wallNet: max(0, gross - openings), ceiling: floor,
                            perimeter: perimeter, baseboardLength: max(0, perimeter - doors))
    }

    static func material(_ item: MaterialPlan, rooms: [RoomPlan], code: String = "USD") -> MaterialEstimate {
        let room = rooms.first { $0.id == item.roomID }
        let m = room.map { self.room($0) }
        let raw: Double
        switch item.surface {
        case .floor: raw = m?.floor ?? 0
        case .walls: raw = m?.wallNet ?? 0
        case .ceiling: raw = m?.ceiling ?? 0
        case .perimeter: raw = m?.baseboardLength ?? 0
        case .manual: raw = item.manualQuantity
        }
        let base = max(0, raw) * Double(max(1, item.coats))
        let needed = base * (1 + min(100, max(0, item.wastePercent)) / 100)
        // Decimal arithmetic avoids binary floating-point rounding a whole package up.
        let decimalRaw: Decimal
        if let room {
            let length = decimal(room.length), width = decimal(room.width), height = decimal(room.height)
            let perimeter = 2 * (length + width)
            switch item.surface {
            case .floor, .ceiling: decimalRaw = length * width
            case .walls:
                let openings = room.openings.reduce(Decimal.zero) {
                    $0 + decimal($1.width) * decimal($1.height) * Decimal($1.count)
                }
                decimalRaw = max(0, perimeter * height - openings)
            case .perimeter:
                let doors = room.openings.filter { $0.kind == .door }.reduce(Decimal.zero) {
                    $0 + decimal($1.width) * Decimal($1.count)
                }
                decimalRaw = max(0, perimeter - doors)
            case .manual: decimalRaw = decimal(item.manualQuantity)
            }
        } else {
            decimalRaw = item.surface == .manual ? decimal(item.manualQuantity) : 0
        }
        let decimalCoverage = decimal(item.coveragePerPack)
        var packageRatio = decimalCoverage > 0
            ? decimalRaw * Decimal(max(1, item.coats)) * (1 + decimal(min(100, max(0, item.wastePercent))) / 100) / decimalCoverage
            : Decimal.nan
        var roundedPackages = Decimal.zero
        NSDecimalRound(&roundedPackages, &packageRatio, 0, .up)
        let exceedsLimit = roundedPackages.isNaN || roundedPackages >= Decimal(Int.max)
        let computedPacks = exceedsLimit ? Int.max : max(0, NSDecimalNumber(decimal: roundedPackages).intValue)
        let packs = max(0, item.overridePacks ?? computedPacks)
        let price = decimal(item.unitPrice.isFinite ? max(0, item.unitPrice) : 0)
        let total = rounded(Decimal(packs) * price, code: code)
        return MaterialEstimate(material: item, roomName: room?.name ?? "Removed room",
                                baseQuantity: base, requiredQuantity: needed, packs: packs, cost: total,
                                quantityExceedsLimit: item.overridePacks == nil && exceedsLimit)
    }

    static func estimates(_ doc: ProjectContent) -> [MaterialEstimate] {
        doc.materials.map { material($0, rooms: doc.rooms, code: doc.currencyCode) }
    }

    static func budget(_ doc: ProjectContent) -> BudgetSummary {
        budget(doc, estimates: estimates(doc))
    }

    static func budget(_ doc: ProjectContent, estimates: [MaterialEstimate]) -> BudgetSummary {
        let subtotal = estimates.reduce(Decimal.zero) { $0 + $1.cost }
        let rate = decimal(max(0, min(100, doc.taxPercent))) / Decimal(100)
        let tax = rounded(subtotal * rate, code: doc.currencyCode)
        let shipping = rounded(decimal(max(0, doc.shipping)), code: doc.currencyCode)
        return BudgetSummary(subtotal: subtotal, tax: tax, shipping: shipping,
                             total: subtotal + tax + shipping)
    }

    // Decimal(Double) can preserve binary approximation and push exact package
    // boundaries above an integer. Parse Double's shortest decimal representation.
    static func decimal(_ value: Double) -> Decimal {
        guard value.isFinite else { return .nan }
        return Decimal(string: String(value), locale: Locale(identifier: "en_US_POSIX")) ?? .nan
    }

    static func rounded(_ number: Decimal, code: String = "USD") -> Decimal {
        var input = number
        var output = Decimal()
        NSDecimalRound(&output, &input, code == "JPY" ? 0 : 2, .plain)
        return output
    }

    static func money(_ amount: Decimal, code: String) -> String {
        amount.formatted(.currency(code: code).locale(Locale(identifier: "en_US")))
    }

    static func measure(_ quantity: Double, unit: String = "m²") -> String {
        "\(quantity.formatted(.number.precision(.fractionLength(0...2)))) \(unit)"
    }
}
