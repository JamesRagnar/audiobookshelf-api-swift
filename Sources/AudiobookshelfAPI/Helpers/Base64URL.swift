import Foundation

/// Encodes UTF-8 text using the URL-safe Base64 alphabet without percent-encoding.
/// Audiobookshelf decodes the resulting path segment with Node's Base64 decoder.
enum Base64URL {

    static func encode(_ value: String) -> String {
        Data(value.utf8)
            .base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }

}
