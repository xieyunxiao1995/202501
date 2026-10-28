import Foundation

struct WelcomeTourPage: Identifiable, Hashable {
    let id: Int
    let symbol: String
    let eyebrow: String
    let title: String
    let message: String

    static let all: [WelcomeTourPage] = [
        WelcomeTourPage(
            id: 0,
            symbol: "house.fill",
            eyebrow: "WELCOME",
            title: "Welcome to HomeMeasure",
            message: "Plan rooms, estimate materials and prepare a purchase list. Everything stays on this iPhone, with no account and no connection required."
        ),
        WelcomeTourPage(
            id: 1,
            symbol: "ruler",
            eyebrow: "STEP 1 · MEASURE",
            title: "Turn room sizes into clear numbers",
            message: "Enter length, width and height, then subtract doors and windows to see usable floor, wall and baseboard measurements."
        ),
        WelcomeTourPage(
            id: 2,
            symbol: "shippingbox",
            eyebrow: "STEP 2 · ESTIMATE",
            title: "Buy whole packages, not odd decimals",
            message: "Choose a surface, coverage per package and a waste allowance. HomeMeasure rounds up to packages you can actually buy, and you can override the count."
        ),
        WelcomeTourPage(
            id: 3,
            symbol: "cart",
            eyebrow: "STEP 3 · SHOP",
            title: "One purchase list across projects",
            message: "Search materials, follow purchase progress and mark items bought. Then export a tidy PDF report or a JSON backup whenever you need one."
        )
    ]
}
