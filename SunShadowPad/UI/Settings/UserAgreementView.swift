import SwiftUI

struct UserAgreementView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                section("Use of the App", "SunShadowPad provides personal, on-device tools for creating schematic outdoor scenes, estimating theoretical direct sunlight and comparing layouts. You are responsible for the dimensions, location and assumptions that you enter.")
                section("Planning Estimates", "The calculations assume horizontal ground, idealized solar rays and opaque simplified obstacles. They do not account for clouds, weather, terrain elevation, unknown neighbouring buildings, material transmission or local building codes. This is not a surveying, engineering or safety certification product.")
                section("Local Files", "You retain control over projects stored on your device. Exported project files can be imported by anyone who receives them; avoid sharing sensitive site coordinates unless intended.")
                section("Intellectual Property", "You remain responsible for using maps, reference plans, text and other materials only when you have permission to do so.")
                section("Availability", "The app can be used without a network connection. Device limitations, storage availability and operating-system changes may affect functionality. Back up important projects before deleting the app.")
                section("Responsible Use", "Do not rely on the estimated light exposure for decisions that require an on-site assessment, certified professional or applicable authority approval.")
                section("Contact", "\(AppInfo.supportContactSentence) This agreement is provided by \(AppInfo.developer).")
                Text("Agreement version: 1.0  •  2 November 2026")
                    .font(.caption).foregroundStyle(AppTheme.textMuted)
            }.padding(18)
        }
        .background(AppTheme.navy.ignoresSafeArea())
        .navigationTitle("User Agreement")
    }
    private func section(_ heading: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(heading).font(.headline).foregroundStyle(AppTheme.yellow)
            Text(body).font(.subheadline)
        }
    }
}
