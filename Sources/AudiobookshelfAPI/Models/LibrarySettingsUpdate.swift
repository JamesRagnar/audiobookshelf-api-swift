/// Library settings writes on 2.26.0...2.37.1. Nil properties omit their keys.
/// Media-inapplicable settings are ignored. Metadata source names remain open strings:
/// folderStructure, audioMetatags, nfoFile, txtFiles, opfFile and absMetadata.
public struct LibrarySettingsUpdate: Encodable, Sendable {

    /// Wire key coverAspectRatio: 0 rectangular, 1 square; nil omits.
    public let coverAspectRatio: Int?

    /// Wire key disableWatcher: Disable folder watcher; nil omits.
    public let disableWatcher: Bool?

    /// Wire key skipMatchingMediaWithAsin: Book-only ASIN matching rule; nil omits.
    public let skipMatchingMediaWithAsin: Bool?

    /// Wire key skipMatchingMediaWithIsbn: Book-only ISBN matching rule; nil omits.
    public let skipMatchingMediaWithIsbn: Bool?

    /// Wire key audiobooksOnly: Book-only setting to hide ebook-only items; nil omits.
    public let audiobooksOnly: Bool?

    /// Wire key epubsAllowScriptedContent: Book-only EPUB script permission; nil omits.
    public let epubsAllowScriptedContent: Bool?

    /// Wire key hideSingleBookSeries: Book-only single-book series visibility; nil omits.
    public let hideSingleBookSeries: Bool?

    /// Wire key onlyShowLaterBooksInContinueSeries: Book-only continue-series visibility; nil omits.
    public let onlyShowLaterBooksInContinueSeries: Bool?

    /// Wire key metadataPrecedence: Book-only ordered sources; [] explicitly empties the list; nil omits.
    public let metadataPrecedence: [String]?

    /// Wire key autoScanCronExpression: update null disables auto-scan; nil omits.
    /// Creation ignores null/empty and keeps its default.
    public let autoScanCronExpression: NullableUpdate<String>?

    /// Wire key podcastSearchRegion: Podcast-only region; update accepts null; creation ignores null/empty; nil omits.
    public let podcastSearchRegion: NullableUpdate<String>?

    /// Wire key markAsFinishedPercentComplete: 0...100 percent; null clears the threshold; nil omits.
    public let markAsFinishedPercentComplete: NullableUpdate<Double>?

    /// Wire key markAsFinishedTimeRemaining: Nonnegative seconds; null clears the threshold; nil omits.
    public let markAsFinishedTimeRemaining: NullableUpdate<Double>?

    /// Creates a partial settings write. Every argument uses its matching wire key.
    /// Omitted arguments preserve settings during update; creation uses server defaults.
    /// NullableUpdate.null sends JSON null, with the property-specific behavior above.
    /// - Parameters:
    ///   - coverAspectRatio: Wire coverAspectRatio, 0 rectangular/1 square; nil omits.
    ///   - disableWatcher: Wire disableWatcher Boolean; nil omits.
    ///   - skipMatchingMediaWithAsin: Book-only wire Boolean; nil omits.
    ///   - skipMatchingMediaWithIsbn: Book-only wire Boolean; nil omits.
    ///   - audiobooksOnly: Book-only wire Boolean hiding ebook-only items; nil omits.
    ///   - epubsAllowScriptedContent: Book-only wire Boolean allowing EPUB scripts; nil omits.
    ///   - hideSingleBookSeries: Book-only wire Boolean; nil omits.
    ///   - onlyShowLaterBooksInContinueSeries: Book-only wire Boolean; nil omits.
    ///   - metadataPrecedence: Ordered open source-name strings; nil omits, [] empties.
    ///   - autoScanCronExpression: Cron string or explicit null; nil omits.
    ///     Update null disables scanning; creation ignores null/empty and retains defaults.
    ///   - podcastSearchRegion: Podcast region string or explicit null; nil omits.
    ///     Creation ignores null/empty and retains defaults.
    ///   - markAsFinishedPercentComplete: 0...100 percent or null to clear; nil omits.
    ///   - markAsFinishedTimeRemaining: Nonnegative fractional seconds or null to clear; nil omits.
    public init(
        coverAspectRatio: Int? = nil,
        disableWatcher: Bool? = nil,
        skipMatchingMediaWithAsin: Bool? = nil,
        skipMatchingMediaWithIsbn: Bool? = nil,
        audiobooksOnly: Bool? = nil,
        epubsAllowScriptedContent: Bool? = nil,
        hideSingleBookSeries: Bool? = nil,
        onlyShowLaterBooksInContinueSeries: Bool? = nil,
        metadataPrecedence: [String]? = nil,
        autoScanCronExpression: NullableUpdate<String>? = nil,
        podcastSearchRegion: NullableUpdate<String>? = nil,
        markAsFinishedPercentComplete: NullableUpdate<Double>? = nil,
        markAsFinishedTimeRemaining: NullableUpdate<Double>? = nil
    ) {
        self.coverAspectRatio = coverAspectRatio
        self.disableWatcher = disableWatcher
        self.skipMatchingMediaWithAsin = skipMatchingMediaWithAsin
        self.skipMatchingMediaWithIsbn = skipMatchingMediaWithIsbn
        self.audiobooksOnly = audiobooksOnly
        self.epubsAllowScriptedContent = epubsAllowScriptedContent
        self.hideSingleBookSeries = hideSingleBookSeries
        self.onlyShowLaterBooksInContinueSeries = onlyShowLaterBooksInContinueSeries
        self.metadataPrecedence = metadataPrecedence
        self.autoScanCronExpression = autoScanCronExpression
        self.podcastSearchRegion = podcastSearchRegion
        self.markAsFinishedPercentComplete = markAsFinishedPercentComplete
        self.markAsFinishedTimeRemaining = markAsFinishedTimeRemaining
    }

}
