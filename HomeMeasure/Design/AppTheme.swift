import SwiftUI

enum AppTheme {
    static let deep = Color(red: 23/255, green: 59/255, blue: 75/255)
    static let slate = Color(red: 70/255, green: 126/255, blue: 148/255)
    static let glacier = Color(red: 117/255, green: 179/255, blue: 191/255)
    static let mist = Color(red: 220/255, green: 239/255, blue: 240/255)
    static let paper = Color(red: 247/255, green: 250/255, blue: 249/255)
    static let gold = Color(red: 226/255, green: 173/255, blue: 114/255)
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon).foregroundStyle(AppTheme.slate).font(.title3)
            Text(value).font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(AppTheme.deep).minimumScaleFactor(0.7).lineLimit(1)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16).background(.white, in: RoundedRectangle(cornerRadius: 20))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue(value)
    }
}

struct EmptyPanel: View {
    let symbol: String
    let heading: String
    let detail: String
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: symbol).font(.system(size: 40, weight: .light))
                .foregroundStyle(AppTheme.slate).padding(18)
                .background(AppTheme.mist, in: Circle())
                .accessibilityHidden(true)
            Text(heading).font(.headline).foregroundStyle(AppTheme.deep)
            Text(detail).font(.subheadline).foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }.frame(maxWidth: .infinity).padding(30)
    }
}

struct SectionTitle: View {
    let title: String
    var body: some View {
        Text(title).font(.system(.headline, design: .rounded, weight: .bold))
            .foregroundStyle(AppTheme.deep)
    }
}

struct PrimaryActionStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 14)
            .background(AppTheme.deep, in: RoundedRectangle(cornerRadius: 15))
            .opacity(configuration.isPressed ? 0.76 : 1)
    }
}
