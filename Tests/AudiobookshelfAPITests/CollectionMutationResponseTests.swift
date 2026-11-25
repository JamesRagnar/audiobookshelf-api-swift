import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct CollectionMutationResponseTests {

    enum Mutation: CaseIterable {
        case create
        case update
        case addBook
        case removeBook
        case batchAddBooks
        case batchRemoveBooks

        func handle(_ json: String) throws -> AudiobookshelfAPI.Collection? {
            let url = try #require(URL(string: "https://example.invalid/api/collections"))
            let response = try #require(HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            ))
            let input = (data: Data(json.utf8), response: response)
            switch self {
            case .create:
                return try CreateCollection.handle(input)

            case .update:
                return try UpdateCollection.handle(input)

            case .addBook:
                return try CollectionAddBook.handle(input)

            case .removeBook:
                return try CollectionRemoveBook.handle(input)

            case .batchAddBooks:
                return try CollectionBatchAddBooks.handle(input)

            case .batchRemoveBooks:
                return try CollectionBatchRemoveBooks.handle(input)
            }
        }
    }

    @Test(arguments: Mutation.allCases)
    func nullMeansSuccessfulMutationWithoutVisibleCollection(mutation: Mutation) throws {
        #expect(try mutation.handle("null") == nil)
    }

    @Test(arguments: Mutation.allCases)
    func expandedCollectionPreservesIdentityAndBook(mutation: Mutation) throws {
        let collection = try #require(try mutation.handle(collectionJSON(books: TestFixtures.bookLibraryItemJSON)))

        #expect(collection.id == "collection-1")
        #expect(collection.libraryId == "library-1")
        #expect(collection.books.ids == ["li-1"])
        let books = try #require(collection.books.items)
        #expect(books.count == 1)
        #expect(books.first?.id == "li-1")
    }

    @Test(arguments: Mutation.allCases)
    func genuinelyEmptyCollectionRemainsAnObject(mutation: Mutation) throws {
        let collection = try #require(try mutation.handle(collectionJSON(books: "")))

        #expect(collection.id == "collection-1")
        #expect(collection.libraryId == "library-1")
        #expect(collection.books.ids.isEmpty)
    }

    @Test(arguments: Mutation.allCases)
    func malformedNonNullCollectionThrowsDecodingError(mutation: Mutation) {
        let json = collectionJSON(books: "").replacingOccurrences(of: "\"id\": \"collection-1\",", with: "")
        #expect {
            try mutation.handle(json)
        } throws: { error in
            guard let responseError = error as? ResponseError,
                  case .decoding = responseError else {
                return false
            }
            return true
        }
    }

    private func collectionJSON(books: String) -> String {
        """
        {
          "id": "collection-1",
          "libraryId": "library-1",
          "name": "Favorites",
          "description": null,
          "books": [\(books)],
          "lastUpdate": 100,
          "createdAt": 50
        }
        """
    }

}
