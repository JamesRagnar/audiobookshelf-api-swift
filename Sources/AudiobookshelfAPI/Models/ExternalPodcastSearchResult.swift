import Foundation

/// Normalized iTunes search result, available on 2.26.0...2.37.1.
/// Optional properties decode missing/null as nil; unrelated non-null types fail.
public struct ExternalPodcastSearchResult: Decodable, Sendable {

    /// Required podcast title, wire key title.
    public let title: String
    /// Optional numeric collection ID, wire key id; strings are rejected.
    public let id: Int?
    /// Optional numeric artist ID, wire key artistId.
    public let artistId: Int?
    /// Optional creator name, wire key artistName.
    public let artistName: String?
    /// Sanitized description, wire key description; normally empty when unavailable.
    public let description: String?
    /// Required plain description, wire key descriptionPlain; empty when unavailable.
    public let descriptionPlain: String
    /// Optional provider date string, wire key releaseDate; preserved verbatim.
    public let releaseDate: String?
    /// Optional genre list, wire key genres; normally [] when unavailable.
    public let genres: [String]?
    /// Optional artwork URL, wire key cover.
    public let cover: String?
    /// Optional provider episode count, wire key trackCount.
    public let trackCount: Int?
    /// Optional RSS URL, wire key feedUrl.
    public let feedUrl: String?
    /// Optional collection-page URL, wire key pageUrl.
    public let pageUrl: String?
    /// Required normalized adult-content flag, wire key explicit.
    public let explicit: Bool

    /// Legacy creator-name alias.
    @available(*, deprecated, renamed: "artistName")
    public var author: String? { artistName }
    /// Legacy artwork URL alias.
    @available(*, deprecated, renamed: "cover")
    public var artwork: String? { cover }
    /// Legacy collection-page URL alias.
    @available(*, deprecated, renamed: "pageUrl")
    public var itunesPageUrl: String? { pageUrl }
    /// Legacy string representation of the numeric collection ID.
    @available(*, deprecated, message: "Use the numeric id property.")
    public var itunesId: String? { id.map(String.init) }

}
