import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct CollectionDecodingTests {

    @Test
    func collectionDecodesExpandedBooksAsItems() throws {
        let collection = try decode(
            """
            {
              "id": "collection-1",
              "libraryId": "library-1",
              "name": "Favorites",
              "description": "Expanded collection",
              "books": [\(bookLibraryItemJSON)],
              "lastUpdate": 100,
              "createdAt": 50
            }
            """
        )

        #expect(collection.books.ids == ["li-1"])
        let items = try #require(collection.books.items)
        #expect(items.count == 1)
        #expect(items.first?.id == "li-1")
    }

    @Test
    func collectionDecodesMinifiedBooksAsIDs() throws {
        let collection = try decode(
            """
            {
              "id": "collection-2",
              "libraryId": "library-1",
              "name": "Queue",
              "description": null,
              "books": ["li-1", "li-2"],
              "lastUpdate": 200,
              "createdAt": 100
            }
            """
        )

        #expect(collection.books.ids == ["li-1", "li-2"])
        #expect(collection.books.items == nil)
    }

    @Test
    func collectionThrowsWhenBooksAreNeitherIDsNorItems() {
        #expect(throws: DecodingError.self) {
            _ = try decode(
                """
                {
                  "id": "collection-3",
                  "libraryId": "library-1",
                  "name": "Broken",
                  "description": null,
                  "books": [1, 2, 3],
                  "lastUpdate": 200,
                  "createdAt": 100
                }
                """
            )
        }
    }

    private func decode(_ json: String) throws -> Collection {
        try JSONDecoder().decode(Collection.self, from: Data(json.utf8))
    }
}

private let bookLibraryItemJSON = """
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
    "metadata": { "title": "Test Book", "genres": [] },
    "tags": []
  }
}
"""
