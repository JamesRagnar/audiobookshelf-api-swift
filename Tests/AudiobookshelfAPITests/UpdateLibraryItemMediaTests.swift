import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct UpdateLibraryItemMediaTests {

    @Test(arguments: [
        ("true", true),
        ("false", false),
        ("null", false),
        ("\"\"", false),
        ("\"https://example.com/cover.jpg\"", true)
    ])
    func normalizesControllerUpdatedValues(raw: String, expected: Bool) throws {
        let response = try JSONDecoder().decode(
            UpdateLibraryItemMedia.Response.self,
            from: Data("{\"updated\":\(raw),\"libraryItem\":\(libraryItemJSON)}".utf8)
        )

        #expect(response.updated == expected)
        #expect(response.libraryItem.id == "item-1")
    }

    @Test(arguments: ["1", "[]", "{}"])
    func rejectsUnsupportedUpdatedTypes(raw: String) {
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(
                UpdateLibraryItemMedia.Response.self,
                from: Data("{\"updated\":\(raw),\"libraryItem\":\(libraryItemJSON)}".utf8)
            )
        }
    }

}

private let libraryItemJSON = """
{
  "id": "item-1",
  "ino": "1",
  "libraryId": "library-1",
  "folderId": "folder-1",
  "path": "/books/item",
  "relPath": "item",
  "isFile": false,
  "addedAt": 1,
  "updatedAt": 2,
  "isMissing": false,
  "isInvalid": false,
  "mediaType": "book",
  "media": {
    "id": "book-1",
    "metadata": { "title": "Book", "genres": [] },
    "tags": []
  }
}
"""
