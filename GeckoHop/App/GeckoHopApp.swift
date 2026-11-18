import SwiftUI

@main
struct GeckConnentApp: App {
    @StateObject private var model: AppModel
    @AppStorage("theme") private var theme = "system"
    @AppStorage("language") private var language = "system"
    @Environment(\.scenePhase) private var phase
    @State private var systemLanguages = Locale.preferredLanguages

    private var appLocale: Locale {
        let code = AppLanguage.resolve(preference: language, preferredLanguages: systemLanguages,
                                       localeLanguage: Locale.current.languageCodeCompat)
        return Locale(identifier: code == "zh" ? "zh-Hans" : "en")
    }

    init() {
        LegacyPreferences.migrate(in: .standard)
#if DEBUG && targetEnvironment(simulator)
        if let run = ProcessInfo.processInfo.environment["GeckConnent_UITEST_RUN"], UUID(uuidString: run) != nil {
            _model = StateObject(wrappedValue: AppModel(api: UITestService.client(run: run.lowercased())))
            return
        }
#endif
        _model = StateObject(wrappedValue: AppModel())
    }

    var body: some Scene {
        WindowGroup {
            HomeView(model: model)
                .environment(\.locale, appLocale)
                .onReceive(NotificationCenter.default.publisher(for: NSLocale.currentLocaleDidChangeNotification)) { _ in
                    systemLanguages = Locale.preferredLanguages
                }
                .onChangeCompat(of: phase) { phase in
                    if phase == .active { systemLanguages = Locale.preferredLanguages }
                }
                .preferredColorScheme(theme == "dark" ? .dark : theme == "light" ? .light : nil)
        }
    }
}
