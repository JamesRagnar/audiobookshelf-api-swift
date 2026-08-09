import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct EbookContractTests {

    @Test
    func statusToggleUsesInodePathAndEmptyBody() throws {
        let request = UpdateEbookFileStatus.Request(itemId: "item-1", fileId: "inode-7")
        let encoded = try request.body.encodeBody(using: RequestEncoder())

        #expect(request.path == "/api/items/item-1/ebook/inode-7/status")
        #expect(encoded.data.isEmpty)
        #expect(encoded.contentType == nil)
    }

    @Test
    func ebookProgressOmitsAudioDefaults() throws {
        let progress = BatchCreateUpdateMediaProgress.Request.ProgressItem(
            libraryItemId: "item-1",
            ebookLocation: "chapter-2",
            ebookProgress: 0.42
        )
        let object = try jsonObject(progress)

        #expect(object["libraryItemId"] as? String == "item-1")
        #expect(object["ebookLocation"] as? String == "chapter-2")
        #expect(object["ebookProgress"] as? Double == 0.42)
        #expect(object["duration"] == nil)
        #expect(object["progress"] == nil)
        #expect(object["startedAt"] == nil)
    }

    @Test
    func eReaderDeviceAccessFieldsRoundTripAndEncode() throws {
        let device = EReaderDevice(
            name: "Kindle",
            email: "kindle@example.com",
            availabilityOption: "specificUsers",
            users: ["user-1"]
        )
        let data = try JSONEncoder().encode(device)
        let decoded = try JSONDecoder().decode(EReaderDevice.self, from: data)
        let request = UpdateUserEReaderDevices.Request(devices: [device])
        let requestObject = try jsonObject(request.body)

        #expect(decoded.availabilityOption == "specificUsers")
        #expect(decoded.users == ["user-1"])
        #expect(requestObject["ereaderDevices"] != nil)
    }

    @Test
    func ebookDeliveryMapsBadRequest() {
        guard case .failure(.error(SendEbookToDevice.AudiobookshelfError.badRequest)) =
            SendEbookToDevice.responses.match(400) else {
            Issue.record("Ebook delivery must map HTTP 400 to badRequest")
            return
        }
    }

    private func jsonObject<T: Encodable>(_ value: T) throws -> [String: Any] {
        try #require(JSONSerialization.jsonObject(with: JSONEncoder().encode(value)) as? [String: Any])
    }
}
