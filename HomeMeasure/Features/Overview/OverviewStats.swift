import Foundation

struct OverviewStats {
    let projectCount: Int
    let roomCount: Int
    let materialCount: Int
    let purchasedCount: Int
    let usdTotal: Decimal
    let usdBudgetIsUnavailable: Bool
    let hasUnreadableProject: Bool

    init(projects: [ProjectRecord]) {
        var rooms = 0
        var materials = 0
        var purchased = 0
        var usdTotal = Decimal.zero
        var usdUnavailable = false
        var unreadable = false

        for project in projects {
            guard let document = try? project.readDetails() else {
                unreadable = true
                continue
            }
            rooms += document.rooms.count
            materials += document.materials.count
            purchased += document.materials.filter(\.purchased).count

            guard document.currencyCode == "USD" else { continue }
            let estimates = EstimationService.estimates(document)
            if estimates.contains(where: \.quantityExceedsLimit) {
                usdUnavailable = true
            } else {
                usdTotal += EstimationService.budget(document, estimates: estimates).total
            }
        }

        projectCount = projects.count
        roomCount = rooms
        materialCount = materials
        purchasedCount = purchased
        self.usdTotal = usdTotal
        usdBudgetIsUnavailable = usdUnavailable
        hasUnreadableProject = unreadable
    }
}
