import SwiftUI

struct LanguageMenu: View {
    @AppLocalized private var L
    @AppStorage("language") private var language = "system"

    var body: some View {
        Menu {
            Picker(L("界面语言", "App language"), selection: $language) {
                Text(L("跟随手机", "Device language")).tag("system")
                Text("简体中文").tag("zh")
                Text("English").tag("en")
            }
        } label: {
            Label(L("语言", "Language"), systemImage: "character.bubble")
                .labelStyle(.iconOnly)
                .frame(minWidth: 44, minHeight: 44)
                .contentShape(Rectangle())
        }
        .accessibilityIdentifier("app.language")
        .accessibilityValue(L("简体中文", "English"))
    }
}
