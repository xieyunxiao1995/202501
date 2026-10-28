import Foundation
import UIKit
import ImageIO

// All photos remain in the app sandbox. PhotosPicker supplies only selected media.
enum RoomPhotoService {
    private static var folder: URL {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return support.appendingPathComponent("RoomPhotos", isDirectory: true)
    }

    static func save(_ data: Data) throws -> String {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let thumbnail = CGImageSourceCreateThumbnailAtIndex(source, 0, [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: 1440,
                kCGImageSourceCreateThumbnailWithTransform: true
              ] as CFDictionary) else { throw CocoaError(.fileReadCorruptFile) }
        let image = UIImage(cgImage: thumbnail)
        guard let jpeg = image.jpegData(compressionQuality: 0.78) else {
            throw CocoaError(.fileWriteInapplicableStringEncoding)
        }
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let name = UUID().uuidString + ".jpg"
        try jpeg.write(to: folder.appendingPathComponent(name), options: .atomic)
        return name
    }

    static func image(_ name: String?) -> UIImage? {
        guard let name, name == (name as NSString).lastPathComponent else { return nil }
        return UIImage(contentsOfFile: folder.appendingPathComponent(name).path)
    }
}

extension RoomPhotoService {
    static func delete(_ name: String?) {
        guard let name, name == (name as NSString).lastPathComponent else { return }
        try? FileManager.default.removeItem(at: folder.appendingPathComponent(name))
    }
    static func removeAll() throws {
        guard FileManager.default.fileExists(atPath: folder.path) else { return }
        try FileManager.default.removeItem(at: folder)
    }
}
