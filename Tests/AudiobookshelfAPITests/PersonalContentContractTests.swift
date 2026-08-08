import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct PersonalContentContractTests {

    @Test
    func mediaProgressResponseDecodesWrappedArray() throws {
        let body = Data(
            """
            {
              "mediaProgress": [{
                "id": "progress-1",
                "userId": "user-1",
                "libraryItemId": "library-item-1",
                "mediaItemId": "media-item-1",
                "mediaItemType": "book",
                "duration": 3600,
                "progress": 0.25,
                "currentTime": 900,
                "isFinished": false,
                "hideFromContinueListening": false,
                "lastUpdate": 1737600000000,
                "startedAt": 1737000000000
              }]
            }
            """.utf8
        )

        let decoded = try GetAllMediaProgress.handle(
            (data: body, response: makeResponse())
        )

        #expect(decoded.mediaProgress.first?.libraryItemId == "library-item-1")
        #expect(GetAllMediaProgress.Request().path == "/api/me/progress")
    }

    @Test
    func bookmarkResponsesDecodeWrappedArray() throws {
        let all = try GetYourBookmarks.handle(
            (data: bookmarksJSON, response: makeResponse())
        )
        let itemRequest = GetYourBookmarksForLibraryItem.Request(
            libraryItemID: "library-item-1"
        )
        let item = try GetYourBookmarksForLibraryItem.handle(
            (data: bookmarksJSON, response: makeResponse())
        )

        #expect(all.bookmarks.first?.title == "Chapter 3")
        #expect(GetYourBookmarks.Request().path == "/api/me/bookmarks")
        #expect(itemRequest.path == "/api/me/bookmarks/library-item-1")
        #expect(item.bookmarks.first?.libraryItemId == "library-item-1")
    }

    private var bookmarksJSON: Data {
        Data(
            """
            {
              "bookmarks": [{
                "libraryItemId": "library-item-1",
                "title": "Chapter 3",
                "time": 1234.5,
                "createdAt": 1737600000000
              }]
            }
            """.utf8
        )
    }

    private func makeResponse() throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))
    }

}
