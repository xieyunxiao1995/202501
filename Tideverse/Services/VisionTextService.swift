import Foundation
import Vision
import ImageIO

struct VisionTextService {
    enum TextError: LocalizedError {
        case unreadable
        var errorDescription: String? { "No readable text was found in that image." }
    }

    /// Optional on-device OCR, performed only when the user selects "Read text".
    static func extractText(from imageData: Data) async throws -> String {
        try await Task.detached(priority: .userInitiated) {
            guard let source = CGImageSourceCreateWithData(imageData as CFData, nil),
                  let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
                throw TextError.unreadable
            }
            let request = VNRecognizeTextRequest()
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en-US"]
            try VNImageRequestHandler(cgImage: cgImage, options: [:]).perform([request])
            let text = (request.results ?? [])
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            guard !text.isEmpty else { throw TextError.unreadable }
            return String(text.prefix(4000))
        }.value
    }
}
