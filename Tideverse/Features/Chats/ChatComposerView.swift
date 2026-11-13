import SwiftUI

struct ChatComposerView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let characterName: String
    let isSending: Bool
    @Binding var draft: String
    @FocusState.Binding var isFocused: Bool
    let send: () -> Void
    let cancel: () -> Void

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            TextField("Message \(characterName)…", text: $draft, axis: .vertical)
                .lineLimit(1...4).padding(.horizontal, 12).padding(.vertical, 11)
                .background(TideColors.soft, in: RoundedRectangle(cornerRadius: 18))
                .focused($isFocused)
                .accessibilityIdentifier("chatComposerField")
            Button(isSending ? "Stop reply" : "Send message", systemImage: isSending ? "stop.fill" : "arrow.up", action: isSending ? cancel : send)
                .labelStyle(.iconOnly).font(.headline.bold())
                .contentTransition(reduceMotion ? .identity : .symbolEffect(.replace))
                .foregroundStyle(TideColors.canvas).frame(width: 44, height: 44)
                .background(TideColors.primary, in: Circle())
                .accessibilityIdentifier(isSending ? "chatStop" : "chatSend")
                .disabled(!isSending && draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 10).padding(.vertical, 9)
        .background(TideColors.card)
        .overlay(alignment: .top) { Rectangle().fill(TideColors.border.opacity(0.6)).frame(height: 0.5) }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isFocused = false }
                    .accessibilityIdentifier("dismissKeyboard")
            }
        }
    }
}
