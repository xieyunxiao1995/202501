import SwiftUI

struct ShoppingEmptyResults: View {
    let search: String
    let showPurchased: Bool

    var body: some View {
        if search.isEmpty {
            ContentUnavailableView("Nothing to show",
                                   systemImage: "checkmark.circle",
                                   description: Text(showPurchased
                                                     ? "No materials match this view yet."
                                                     : "Every material is marked as purchased. Turn on Show purchased items to review them."))
        } else {
            ContentUnavailableView.search(text: search)
        }
    }
}
