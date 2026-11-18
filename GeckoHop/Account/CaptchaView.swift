import ImageIO
import SwiftUI

struct CaptchaView: View {
    @AppLocalized private var L
    let api: APIClient
    let email: String
    let purpose: String
    let redeem: (String) async throws -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var challenge: CaptchaChallenge?
    @State private var offset = 0.0
    @State private var loading = false
    @State private var error: String?

    var body: some View {
        NavigationStackCompat {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(L("移动滑块，让拼图对准缺口。", "Move the slider to fit the piece into the opening."))
                        .foregroundStyle(.secondary)
                    if let challenge {
                        puzzle(challenge)
                        Slider(value: $offset, in: 0...(challenge.width - challenge.pieceWidth), step: 1)
                            .accessibilityLabel(L("拼图水平位置", "Puzzle horizontal position"))
                        Button(L("验证", "Verify")) { Task { await verify(challenge) } }
                            .buttonStyle(.borderedProminent).disabled(loading)
                    }
                    if loading { ProgressView() }
                    if let error { StatusBanner(tone: .failure, message: error) }
                    Button(L("重新取题", "Load another puzzle")) { Task { await load() } }
                        .disabled(loading)
                }
                .padding(24)
                .frame(maxWidth: 500)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle(L("对齐拼图", "Align the puzzle"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button(L("取消", "Cancel")) { dismiss() }.disabled(loading) } }
        }
        .interactiveDismissDisabled(loading)
        .task { await load() }
    }

    private func puzzle(_ challenge: CaptchaChallenge) -> some View {
        GeometryReader { proxy in
            let scale = proxy.size.width / challenge.width
            ZStack(alignment: .topLeading) {
                picture(challenge.background)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                picture(challenge.piece)
                    .frame(width: challenge.pieceWidth * scale, height: challenge.pieceWidth * scale)
                    .offset(x: offset * scale, y: challenge.y * scale)
            }
            .clipped()
        }
        .aspectRatio(challenge.width / challenge.height, contentMode: .fit)
        .accessibilityHidden(true)
    }

    private func picture(_ data: Data) -> some View {
        Group {
            if let source = CGImageSourceCreateWithData(data as CFData, nil),
               let image = CGImageSourceCreateImageAtIndex(source, 0, nil) {
                Image(decorative: image, scale: 1).resizable()
            }
        }
    }

    private func load() async {
        guard !loading else { return }
        loading = true
        defer { loading = false }
        error = nil
        challenge = nil
        do {
            challenge = try await api.loadPuzzle(email: email, purpose: purpose)
            offset = 0
        } catch { if !Task.isCancelled { self.error = error.localizedDescription } }
    }

    private func verify(_ challenge: CaptchaChallenge) async {
        guard !loading else { return }
        loading = true
        error = nil
        self.challenge = nil
        defer { loading = false }
        do {
            let ticket = try await api.verifyPuzzle(challenge, position: offset)
            try Task.checkCancellation()
            try await redeem(ticket)
            dismiss()
        } catch {
            if !Task.isCancelled { self.error = error.localizedDescription }
        }
    }
}
