import Foundation

struct ShoppingSection: Identifiable {
    let project: ProjectRecord
    let currencyCode: String
    let lines: [MaterialEstimate]
    var id: UUID { project.id }
}

struct ShoppingContent {
    let totalCount: Int
    let purchasedCount: Int
    let hasUnreadableProject: Bool
    let sections: [ShoppingSection]

    init(projects: [ProjectRecord], showPurchased: Bool, search: String) {
        var total = 0
        var purchased = 0
        var unreadable = false
        var sections: [ShoppingSection] = []

        for project in projects {
            guard let document = try? project.readDetails() else {
                unreadable = true
                continue
            }
            total += document.materials.count
            purchased += document.materials.filter(\.purchased).count

            let lines = EstimationService.estimates(document).filter { line in
                (showPurchased || !line.material.purchased)
                && (search.isEmpty || line.material.name.localizedStandardContains(search))
            }
            if !lines.isEmpty {
                sections.append(ShoppingSection(project: project,
                                                currencyCode: document.currencyCode,
                                                lines: lines))
            }
        }

        totalCount = total
        purchasedCount = purchased
        hasUnreadableProject = unreadable
        self.sections = sections
    }
}
