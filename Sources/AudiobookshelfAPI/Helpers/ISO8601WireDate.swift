import Foundation

/// Property-local ISO dates; never changes the caller's date decoding strategy.
extension KeyedDecodingContainer {

    func decodeISODate(forKey key: Key) throws -> Date {
        let string = try decode(String.self, forKey: key)
        let pattern = #"[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}"#
            + #"(?:\.[0-9]+)?(?:Z|[+-][0-9]{2}:[0-9]{2})"#
        if string.range(of: pattern, options: .regularExpression) == string.startIndex..<string.endIndex {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.isLenient = false
            formatter.dateFormat = string.contains(".")
                ? "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" : "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = formatter.date(from: string) { return date }
        }
        throw DecodingError.dataCorruptedError(
            forKey: key, in: self, debugDescription: "Expected an ISO-8601 date string."
        )
    }

    func decodeISODateIfPresent(forKey key: Key) throws -> Date? {
        guard contains(key), try !decodeNil(forKey: key) else { return nil }
        return try decodeISODate(forKey: key)
    }

}
