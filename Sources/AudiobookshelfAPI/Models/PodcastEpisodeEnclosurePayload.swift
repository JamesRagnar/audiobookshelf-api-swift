/// Download enclosure write on 2.26.0+; optional nil properties omit their keys.
public struct PodcastEpisodeEnclosurePayload: Encodable, Sendable {

    /// Required media URL, wire key url.
    public let url: String
    /// Optional MIME type, wire key type.
    public let type: String?
    /// Optional byte-count string, wire key length.
    public let length: String?

    /// Creates an enclosure. URL is always sent; nil type/length are omitted.
    public init(url: String, type: String? = nil, length: String? = nil) {
        self.url = url
        self.type = type
        self.length = length
    }

}
