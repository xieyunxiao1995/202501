import SwiftUI

struct TideSearchField: View {
    let prompt: String
    @Binding var text: String
    @FocusState private var focused: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(TideColors.muted)
                .accessibilityHidden(true)
            TextField(prompt, text: $text,
                      prompt: Text(prompt).foregroundStyle(TideColors.muted), axis: .vertical)
                .lineLimit(1...3)
                .padding(.vertical, 10)
                .font(.body)
                .foregroundStyle(TideColors.ink)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .focused($focused)
                .onSubmit { focused = false }
                .accessibilityIdentifier("contentSearch")

            if !text.isEmpty {
                Button("Clear search", systemImage: "xmark.circle.fill") { text = "" }
                    .labelStyle(.iconOnly)
                    .accessibilityIdentifier("clearContentSearch")
                    .foregroundStyle(TideColors.bright)
                    .frame(minWidth: 44, minHeight: 44)
                    .contentShape(Rectangle())
                    .buttonStyle(.plain)

            }
        }
        .padding(.leading, 14).padding(.trailing, 4)
        .frame(minHeight: 50)
        .background(TideColors.soft, in: RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 20).padding(.vertical, 8)
        .background(TideColors.canvas)
        .toolbar {
            if focused {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { focused = false }
                        .accessibilityIdentifier("finishSearch")
                }
            }
        }
    }
}
