import Foundation
import PhotosUI
import SwiftUI
import ImageIO
import UIKit

struct ImagePreparationService {
    enum PreparationError: LocalizedError {
        case unreadable
        case tooLarge
        var errorDescription: String? {
            switch self {
            case .unreadable: return "The selected photo could not be opened."
            case .tooLarge: return "This image is too large to attach. Choose a smaller photo."
            }
        }
    }

    /// Re-encodes a user-selected image as JPEG; does not preserve location/EXIF metadata.
    static func prepare(_ selected: PhotosPickerItem) async throws -> Data {
        guard let original = try await selected.loadTransferable(type: Data.self) else {
            throw PreparationError.unreadable
        }
        return try prepare(imageData: original)
    }

    /// The same processing path is used by the picker and privacy/bounds checks.
    static func prepare(imageData: Data) throws -> Data {
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            throw PreparationError.unreadable
        }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: 1024
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {
            throw PreparationError.unreadable
        }
        let image = UIImage(cgImage: cgImage)
        let format = UIGraphicsImageRendererFormat()
        // Pixel dimensions must not depend on the phone's 2x/3x display scale.
        format.scale = 1
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
        let data = renderer.jpegData(withCompressionQuality: 0.64) { _ in
            UIColor.white.setFill()
            UIRectFill(CGRect(origin: .zero, size: image.size))
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }
        guard data.count <= 1_800_000 else { throw PreparationError.tooLarge }
        return data
    }
}
