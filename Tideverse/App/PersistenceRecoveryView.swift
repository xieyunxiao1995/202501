import SwiftUI

struct PersistenceRecoveryView: View {
    let diagnostic: String?
    let retry: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Image(systemName: "externaldrive.badge.exclamationmark")
                    .font(.largeTitle).foregroundStyle(TideColors.bright)
                Text("Your archive could not be opened.").font(.largeTitle.bold())
                Text("Your saved files have not been erased. Check that this device has available storage, unlock it, then try again. If this continues, contact support before removing the app.")
                    .foregroundStyle(TideColors.muted)
                TidePrimaryButton(title: "Try Again", systemImage: "arrow.clockwise", action: retry)
                if let url = AppConfiguration.supportMailURL(subject: "Tideverse Archive Help", body: "App: \(AppConfiguration.version) (\(AppConfiguration.build))\nStorage diagnostic: \(diagnostic ?? "Unavailable")") {
                    Link("Contact Support", destination: url).frame(minHeight: 44)
                }
                if let diagnostic {
                    Text("Diagnostic: \(diagnostic)").font(.footnote.monospaced()).foregroundStyle(TideColors.muted)
                }
            }
            .padding(28)
        }
        .tideBackground().preferredColorScheme(.dark)
    }
}
