import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct BookmarkContractTests {

    @Test
    func wrappedResponsesDecodeFractionalTimes() throws {
        let wrapped = Data(
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

        let all = try GetYourBookmarks.handle((data: wrapped, response: try makeResponse()))
        let item = try GetYourBookmarksForLibraryItem.handle((data: wrapped, response: try makeResponse()))

        #expect(all.bookmarks.first?.time == 1234.5)
        #expect(all.bookmarks.first?.createdAt == 1737600000000)
        #expect(item.bookmarks.first?.time == 1234.5)
    }

    @Test
    func createAndUpdateResponsesDecodeDirectBookmarks() throws {
        let response = try makeResponse()

        let created = try CreateBookmark.handle((data: bookmarkJSON, response: response))
        let updated = try UpdateBookmark.handle((data: bookmarkJSON, response: response))
        _ = try DeleteBookmark.handle((data: Data(), response: response))

        #expect(created.time == 1234.5)
        #expect(updated.title == "Chapter 3")
    }

    @Test
    func bookmarkPayloadsEncodeFractionalTimesAsNumbers() throws {
        let create = CreateBookmark.Request(
            libraryItemId: "library-item-1",
            time: 1234.56789,
            title: "Chapter 3"
        )
        let update = UpdateBookmark.Request(
            libraryItemId: "library-item-1",
            time: 987.654321,
            title: "Chapter 4"
        )

        let createObject = try jsonObject(create.body)
        let updateObject = try jsonObject(update.body)

        #expect(createObject["time"] as? Double == 1234.56789)
        #expect(updateObject["time"] as? Double == 987.654321)
        #expect(updateObject.keys.sorted() == ["time", "title"])
        #expect(createObject["time"] is NSNumber)
        #expect(updateObject["time"] is NSNumber)
    }

    @Test
    func bookmarkEndpointsPreservePathsAndMethods() throws {
        let create = CreateBookmark.Request(libraryItemId: "library-item-1", time: 1.25, title: "One")
        let update = UpdateBookmark.Request(libraryItemId: "library-item-1", time: 1.25, title: "Updated")
        let delete = DeleteBookmark.Request(libraryItemId: "library-item-1", time: 1.25)
        let item = GetYourBookmarksForLibraryItem.Request(libraryItemID: "library-item-1")

        #expect(GetYourBookmarks.Request().method == .get)
        #expect(GetYourBookmarks.Request().path == "/api/me/bookmarks")
        #expect(item.method == .get)
        #expect(item.path == "/api/me/bookmarks/library-item-1")
        #expect(create.method == .post)
        #expect(create.path == "/api/me/item/library-item-1/bookmark")
        #expect(update.method == .patch)
        #expect(update.path == "/api/me/item/library-item-1/bookmark")
        #expect(delete.method == .delete)
        #expect(delete.path == "/api/me/item/library-item-1/bookmark/1.25")
    }

    private let bookmarkJSON = Data(
        """
        {
          "libraryItemId": "library-item-1",
          "title": "Chapter 3",
          "time": 1234.5,
          "createdAt": 1737600000000
        }
        """.utf8
    )

    private func jsonObject<T: Encodable>(_ value: T) throws -> [String: Any] {
        try #require(JSONSerialization.jsonObject(with: JSONEncoder().encode(value)) as? [String: Any])
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
