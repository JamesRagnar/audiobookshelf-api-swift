import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct SocketPayloadCompatibilityTests {

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

}
