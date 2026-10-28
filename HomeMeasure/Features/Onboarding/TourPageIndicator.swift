import SwiftUI

struct TourPageIndicator: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let pageCount: Int
    let selection: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { index in
                Capsule()
                    .fill(index == selection ? AppTheme.mist : AppTheme.mist.opacity(0.34))
                    .frame(width: index == selection ? 24 : 7, height: 7)
            }
        }
        .animation(reduceMotion ? nil : .snappy, value: selection)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Introduction progress")
        .accessibilityValue("Page \(selection + 1) of \(pageCount)")
    }
}
