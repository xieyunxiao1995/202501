import SwiftUI

struct JourneyStatistic: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let value: Int
    let title: String
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: symbol).font(.headline).foregroundStyle(TideColors.bright).frame(height: 24)
            Text(value, format: .number).font(.title2.bold()).monospacedDigit()
                .contentTransition(reduceMotion ? .identity : .numericText())
                .animation(TideMotion.feedback(reduced: reduceMotion), value: value)
            Text(title).font(.caption).foregroundStyle(TideColors.muted).fixedSize(horizontal: false, vertical: true)
        }
        .padding(14).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(TideColors.soft, in: RoundedRectangle(cornerRadius: 20))
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("stat_\(title.lowercased().replacingOccurrences(of: " ", with: ""))")
    }
}
