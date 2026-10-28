import SwiftUI

struct AboutUsView: View {
    private var version: String { Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0" }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: "house.fill").font(.system(size: 48))
                        .foregroundStyle(AppTheme.slate)
                        .frame(width: 100, height: 100)
                        .background(AppTheme.mist, in: RoundedRectangle(cornerRadius: 28))
                    Text("HomeMeasure").font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(AppTheme.deep)
                    Text("Make every measure count.").font(.title3).foregroundStyle(AppTheme.slate)
                }
                InfoBlock(title: "What we're building", text: "HomeMeasure is a focused renovation companion for homeowners, designers and independent contractors who want clearer estimates before purchasing materials.")
                InfoBlock(title: "Thoughtful by design", text: "Measure rectangular rooms, subtract openings, estimate package quantities, organize shopping and create a polished PDF report—without registration or a cloud workspace.")
                InfoBlock(title: "Created by HomeMeasure Studio", text: "HomeMeasure Studio is the product's creative brand. The legal App Store seller is identified on its official App Store listing.")
                InfoBlock(title: "App version", text: "Version \(version) · iPhone · English")
                InfoBlock(title: "Our approach", text: "Quiet interfaces, dependable arithmetic and private, on-device planning. Material estimates are guides; confirm measurements and supplier specifications before placing an order.")
            }.padding(20)
        }
        .background(AppTheme.paper).navigationTitle("About Us")
    }
}

struct InfoBlock: View {
    let title: String
    let text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline).foregroundStyle(AppTheme.deep)
            Text(text).font(.body).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(18).background(.white, in: RoundedRectangle(cornerRadius: 18))
    }
}
