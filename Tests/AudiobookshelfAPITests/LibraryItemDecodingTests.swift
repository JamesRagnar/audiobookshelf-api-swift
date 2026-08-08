import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct LibraryItemDecodingTests {

    // MARK: Book branch

    @Test
    func bookLibraryItemDecodes() throws {
        let item = try decode(TestFixtures.bookLibraryItemJSON)

        #expect(item.id == "li-1")
        #expect(item.libraryId == "lib-1")
        #expect(item.mediaType == .book)
        #expect(item.isMissing == false)
        #expect(item.isInvalid == false)

        guard case .book(let book) = item.media else {
            Issue.record("Expected book media")
            return
        }
        #expect(book.id == "book-1")
        #expect(book.metadata.title == "Test Book")
    }

    @Test
    func bookLibraryItemOptionalFieldsDefaultToNil() throws {
        let item = try decode(TestFixtures.bookLibraryItemJSON)

        #expect(item.oldLibraryItemId == nil)
        #expect(item.lastScan == nil)
        #expect(item.userMediaProgress == nil)
        #expect(item.recentEpisode == nil)
        #expect(item.collapsedSeries == nil)
        #expect(item.libraryFiles == nil)
    }

    // MARK: Podcast branch

    @Test
    func podcastLibraryItemDecodes() throws {
        let item = try decode(TestFixtures.podcastLibraryItemJSON)

        #expect(item.id == "li-2")
        #expect(item.mediaType == .podcast)

        guard case .podcast(let podcast) = item.media else {
            Issue.record("Expected podcast media")
            return
        }
        #expect(podcast.id == "podcast-1")
        #expect(podcast.metadata.title == "Test Podcast")
        #expect(podcast.autoDownloadEpisodes == false)
    }

    // MARK: Unknown mediaType throws

    @Test
    func unknownMediaTypeThrows() {
        let json = TestFixtures.bookLibraryItemJSON.replacingOccurrences(of: "\"book\"", with: "\"video\"")
        #expect(throws: DecodingError.self) {
            try decode(json)
        }
    }

    // MARK: Missing required field throws

    @Test
    func missingIdThrows() {
        let json = TestFixtures.bookLibraryItemJSON.replacingOccurrences(of: "\"id\": \"li-1\",", with: "")
        #expect(throws: DecodingError.self) {
            try decode(json)
        }
    }

    // MARK: BookMetadata series field — array vs single object

    @Test
    func bookMetadataDecodesSeriesAsArray() throws {
        let json = """
        {
          "id": "li-3",
          "ino": "789",
          "libraryId": "lib-1",
          "folderId": "folder-1",
          "path": "/books/test",
          "relPath": "test",
          "isFile": false,
          "addedAt": 1000,
          "updatedAt": 2000,
          "isMissing": false,
          "isInvalid": false,
          "mediaType": "book",
          "media": {
            "id": "book-3",
            "metadata": {
              "title": "Book in Series",
              "genres": [],
              "series": [{ "id": "series-1", "name": "The Series" }]
            },
            "tags": []
          }
        }
        """
        let item = try decode(json)
        guard case .book(let book) = item.media else {
            Issue.record("Expected book media")
            return
        }
        #expect(book.metadata.series?.count == 1)
        #expect(book.metadata.series?.first?.name == "The Series")
    }

    @Test
    func bookMetadataDecodesSeriesAsSingleObject() throws {
        let json = """
        {
          "id": "li-4",
          "ino": "000",
          "libraryId": "lib-1",
          "folderId": "folder-1",
          "path": "/books/test",
          "relPath": "test",
          "isFile": false,
          "addedAt": 1000,
          "updatedAt": 2000,
          "isMissing": false,
          "isInvalid": false,
          "mediaType": "book",
          "media": {
            "id": "book-4",
            "metadata": {
              "title": "Solo Series Book",
              "genres": [],
              "series": { "id": "series-2", "name": "Standalone Series" }
            },
            "tags": []
          }
        }
        """
        let item = try decode(json)
        guard case .book(let book) = item.media else {
            Issue.record("Expected book media")
            return
        }
        #expect(book.metadata.series?.count == 1)
        #expect(book.metadata.series?.first?.name == "Standalone Series")
    }

    // MARK: Helpers

    private func decode(_ json: String) throws -> LibraryItem {
        try JSONDecoder().decode(LibraryItem.self, from: Data(json.utf8))
    }

}
