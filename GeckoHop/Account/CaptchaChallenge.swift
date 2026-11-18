import Foundation

struct CaptchaChallenge: Identifiable {
    let id: String
    let background: Data
    let piece: Data
    let width: Double
    let height: Double
    let pieceWidth: Double
    let y: Double

    init(_ response: [String: Any]) throws {
        func image(_ key: String) -> Data? {
            guard let value = response[key] as? String, value.hasPrefix("data:image/png;base64,"),
                  value.count < 2_000_000 else { return nil }
            return Data(base64Encoded: String(value.dropFirst("data:image/png;base64,".count)))
        }
        guard let id = response["challenge_id"] as? String,
              let background = image("background"), let piece = image("piece"),
              let width = response["width"] as? Double, let height = response["height"] as? Double,
              let pieceWidth = response["piece_width"] as? Double, let y = response["y"] as? Double,
              width.isFinite, height.isFinite, width > pieceWidth, pieceWidth > 0,
              height > 0, y >= 0, y + pieceWidth <= height else {
            throw APIError(code: "response")
        }
        self.id = id
        self.background = background
        self.piece = piece
        self.width = width
        self.height = height
        self.pieceWidth = pieceWidth
        self.y = y
    }
}
