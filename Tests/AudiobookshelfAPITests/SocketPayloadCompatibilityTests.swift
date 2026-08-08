import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct SocketPayloadCompatibilityTests {

    @Test
    func authorRemovedPayloadDecodesIdentifierShape() throws {
        let data = Data(
            #"{"id":"author-1","libraryId":"library-1"}"#.utf8
        )

        let payload = try JSONDecoder().decode(AuthorRemovedEvent.Schema.self, from: data)

        #expect(payload.id == "author-1")
        #expect(payload.libraryId == "library-1")
    }

    @Test
    func authorRemovedPayloadDecodesFullAuthorShape() throws {
        let data = Data(
            #"{"id":"author-1","libraryId":"library-1","name":"Author"}"#.utf8
        )

        let payload = try JSONDecoder().decode(AuthorRemovedEvent.Schema.self, from: data)

        #expect(payload.id == "author-1")
        #expect(payload.libraryId == "library-1")
    }

    @Test
    func itemRemovedPayloadDecodesLegacyIdOnlyShape() throws {
        let data = Data(
            """
            {
              "id": "library-item-123"
            }
            """.utf8
        )

        let payload = try JSONDecoder().decode(ItemRemovedEvent.ItemRemovedPayload.self, from: data)

        #expect(payload.id == "library-item-123")
        #expect(payload.libraryItemIds == ["library-item-123"])
        #expect(payload.libraryId == nil)
    }

    @Test
    func itemRemovedPayloadDecodes2332ShapeWithLibraryId() throws {
        let data = Data(
            """
            {
              "id": "library-item-456",
              "libraryId": "library-789"
            }
            """.utf8
        )

        let payload = try JSONDecoder().decode(ItemRemovedEvent.ItemRemovedPayload.self, from: data)

        #expect(payload.id == "library-item-456")
        #expect(payload.libraryItemIds == ["library-item-456"])
        #expect(payload.libraryId == "library-789")
    }

    @Test
    func itemRemovedPayloadDecodesLegacyIDArray() throws {
        let payload = try JSONDecoder().decode(
            ItemRemovedEvent.ItemRemovedPayload.self,
            from: Data(#"{"libraryItemIds":["item-1","item-2"]}"#.utf8)
        )

        #expect(payload.id == "item-1")
        #expect(payload.libraryItemIds == ["item-1", "item-2"])
    }

    @Test(arguments: [#"{}"#, #"{"libraryItemIds":[]}"#])
    func itemRemovedPayloadRejectsMissingIdentifiers(json: String) {
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(
                ItemRemovedEvent.ItemRemovedPayload.self,
                from: Data(json.utf8)
            )
        }
    }

    @Test
    func authorsNumBooksUpdatedPayloadDecodes236Shape() throws {
        let data = Data(
            """
            {
              "libraryId": "library-1",
              "authors": [
                { "id": "author-1", "numBooks": 4 },
                { "id": "author-2", "numBooks": 1 }
              ]
            }
            """.utf8
        )

        let payload = try JSONDecoder().decode(AuthorsNumBooksUpdatedEvent.Payload.self, from: data)

        #expect(AuthorsNumBooksUpdatedEvent.name == "authors_num_books_updated")
        #expect(payload.libraryId == "library-1")
        #expect(payload.authors.count == 2)
        #expect(payload.authors.first?.id == "author-1")
        #expect(payload.authors.first?.numBooks == 4)
    }

}
