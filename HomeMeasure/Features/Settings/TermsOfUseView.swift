import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Terms of Use").font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(AppTheme.deep)
                Text("Last updated: October 27, 2026").font(.caption).foregroundStyle(.secondary)
                LegalSection(title: "1. Using HomeMeasure", text: "HomeMeasure provides local project planning, room measurement records, material quantity calculations and purchase-list exports. You may use the app for your own lawful personal or professional planning activities.")
                LegalSection(title: "2. Estimation limits", text: "Results depend entirely on the dimensions, coverage rates, waste allowances and prices you enter. The app does not verify site conditions, building codes, supplier specifications, stock availability or contractor pricing. Always re-measure and verify quantities before purchase or installation.")
                LegalSection(title: "3. Your information", text: "Your project records remain under your control on your device. You are responsible for safeguarding your device and any exported backup files, photographs and PDF reports.")
                LegalSection(title: "4. Third-party services", text: "HomeMeasure does not contain advertising, third-party analytics or integrated accounts. When you choose to share a file or feedback using the iOS share sheet, the destination service is governed by its own terms.")
                LegalSection(title: "5. Availability and changes", text: "The app is offered as a planning aid. Features and calculations may evolve with future updates. Users should keep a recent export of important projects before changing devices or reinstalling the app.")
                LegalSection(title: "6. Professional responsibility", text: "The app does not replace a qualified surveyor, architect, designer, electrician, plumber or other licensed professional. You remain responsible for purchasing, safety decisions and compliance with applicable requirements.")
            }.padding(20)
        }.background(AppTheme.paper).navigationTitle("Terms of Use")
    }
}

struct LegalSection: View {
    let title: String
    let text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline).foregroundStyle(AppTheme.deep)
            Text(text).font(.body).foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }.padding(18).frame(maxWidth: .infinity, alignment: .leading)
            .background(.white, in: RoundedRectangle(cornerRadius: 18))
    }
}
