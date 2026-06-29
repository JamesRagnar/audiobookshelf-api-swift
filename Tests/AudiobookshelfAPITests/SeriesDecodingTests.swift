import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct SeriesDecodingTests {

    @Test
    func firstBookUnreadDecodesSingleItemIntoArray() throws {
        let series = try JSONDecoder().decode(
            Series.self,
            from: Data(
                """
                {
                  "id": "series-1",
                  "name": "Series Name",
                  "firstBookUnread": \(seriesBookJSON)
                }
                """.utf8
            )
        )

        let firstUnread = try #require(series.firstBookUnread)
        #expect(firstUnread.count == 1)
        #expect(firstUnread.first?.id == "li-1")
    }
}

private let seriesBookJSON = """
{
  "id": "li-1",
  "ino": "111",
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
    "id": "book-1",
    "metadata": { "title": "Unread Book", "genres": [] },
    "tags": []
  }
}
"""
