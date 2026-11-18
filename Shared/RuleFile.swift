import Foundation
enum RuleFile {
    static let maxSize = 4 << 20

    /// The version of a well-formed rule file, or nil.
    static func version(_ data: Data) -> Int64? {
        let bytes = [UInt8](data), header = 4 + 8 + 5 * 4
        guard bytes.count >= header, bytes.count <= maxSize, bytes.starts(with: "VRS1".utf8) else { return nil }
        func uint(_ offset: Int, _ size: Int) -> UInt64 {
            bytes[offset..<offset + size].reduce(0) { $0 << 8 | UInt64($1) }
        }
        let counts = (0..<5).map { Int(uint(12 + 4 * $0, 4)) }
        guard zip(counts, [8, 8, 8, 8, 32]).reduce(header, { $0 + $1.0 * $1.1 }) == bytes.count else { return nil }
        var offset = header
        // Direct suffixes, direct names, proxy suffixes: ascending hashes.
        for count in counts[0..<3] {
            var previous: UInt64 = 0
            for index in 0..<count {
                let value = uint(offset, 8); offset += 8
                if index > 0 && value < previous { return nil }
                previous = value
            }
        }
        // IPv4 then IPv6 ranges, big-endian: start <= end, after the previous range.
        for (count, width) in [(counts[3], 4), (counts[4], 16)] {
            var previousEnd: ArraySlice<UInt8> = []
            for index in 0..<count {
                let start = bytes[offset..<offset + width], end = bytes[offset + width..<offset + 2 * width]
                offset += 2 * width
                if end.lexicographicallyPrecedes(start) { return nil }
                if index > 0 && !previousEnd.lexicographicallyPrecedes(start) { return nil }
                previousEnd = end
            }
        }
        return Int64(bitPattern: uint(4, 8))
    }
}
