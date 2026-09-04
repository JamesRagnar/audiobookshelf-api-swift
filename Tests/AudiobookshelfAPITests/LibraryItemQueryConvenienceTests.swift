import AudiobookshelfAPI
import Testing

@Suite
struct LibraryItemQueryConvenienceTests {

    @Test
    func seriesQueryUsesSeriesFilterAndSequenceOrdering() {
        let request = GetLibraryItemsForSeries.Request(
            libraryID: "library-1",
            seriesID: "series/one"
        )

        #expect(request.queryItems?["filter"] == "series.c2VyaWVzL29uZQ==")
        #expect(request.queryItems?["sort"] == "sequence")
    }

    @Test
    func seriesQueryAcceptsAnAlternateSort() {
        let request = GetLibraryItemsForSeries.Request(
            libraryID: "library-1",
            seriesID: "series/one",
            sort: .mediaMetadataTitle,
            descending: true
        )

        #expect(request.queryItems?["sort"] == "media.metadata.title")
        #expect(request.queryItems?["desc"] == "1")
    }

    @Test
    func narratorQueryEncodesUTF8NarratorName() {
        let request = GetLibraryItemsForNarrator.Request(
            libraryID: "library-1",
            narratorName: "Zoë Martín"
        )

        #expect(request.queryItems?["filter"] == "narrators.Wm/DqyBNYXJ0w61u")
    }

    @Test
    func filteredQueriesForwardLibraryItemSort() {
        let authorRequest = GetLibraryItemsForAuthor.Request(
            libraryID: "library-1",
            authorID: "author/one",
            sort: .mediaMetadataAuthorName
        )
        let narratorRequest = GetLibraryItemsForNarrator.Request(
            libraryID: "library-1",
            narratorName: "Someone",
            sort: .mediaMetadataTitle
        )

        #expect(authorRequest.queryItems?["sort"] == "media.metadata.authorName")
        #expect(narratorRequest.queryItems?["sort"] == "media.metadata.title")
    }

    @Test
    func authorQueryEncodesAuthorID() {
        let request = GetLibraryItemsForAuthor.Request(
            libraryID: "library-1",
            authorID: "author/one"
        )

        #expect(request.queryItems?["filter"] == "authors.YXV0aG9yL29uZQ==")
    }

}
