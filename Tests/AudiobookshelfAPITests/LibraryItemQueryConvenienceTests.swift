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
    func narratorQueryEncodesUTF8NarratorName() {
        let request = GetLibraryItemsForNarrator.Request(
            libraryID: "library-1",
            narratorName: "Zoë Martín"
        )

        #expect(request.queryItems?["filter"] == "narrators.Wm/DqyBNYXJ0w61u")
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
