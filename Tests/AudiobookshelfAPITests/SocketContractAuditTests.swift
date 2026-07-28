import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

/// Socket event payload shapes corrected against the audiobookshelf 2.36.0 server source.
@Suite
struct SocketContractAuditTests {

    @Test
    func publicUserDecodesUserOnlinePayload() throws {
        let payload = try JSONDecoder().decode(
            UserOnlineEvent.Schema.self,
            from: Data(publicUserJSON.utf8)
        )
        #expect(payload.id == "user-1")
        #expect(payload.type == .user)
        #expect(payload.session == nil)
        #expect(payload.lastSeen == 1737600000000)
    }

    @Test
    func ereaderDevicesUpdatedDecodesWrapper() throws {
        let data = Data(#"{"ereaderDevices": []}"#.utf8)
        let payload = try JSONDecoder().decode(EReaderDevicesUpdatedEvent.Schema.self, from: data)
        #expect(payload.ereaderDevices.isEmpty)
    }

    @Test
    func metadataEmbedQueueUpdateDecodesPerItemShape() throws {
        let data = Data(#"{"libraryItemId": "li-1", "queued": true}"#.utf8)
        let payload = try JSONDecoder().decode(MetadataEmbedQueueUpdate.Schema.self, from: data)
        #expect(payload.libraryItemId == "li-1")
        #expect(payload.queued == true)
    }

    @Test
    func taskProgressDecodesLibraryItemProgressShape() throws {
        let data = Data(#"{"libraryItemId": "li-1", "progress": 42.5}"#.utf8)
        let payload = try JSONDecoder().decode(TaskProgress.Schema.self, from: data)
        #expect(payload.libraryItemId == "li-1")
        #expect(payload.progress == 42.5)
    }

    @Test
    func trackEventsDecodeInoShape() throws {
        let started = try JSONDecoder().decode(
            TrackStartedEvent.Schema.self,
            from: Data(#"{"libraryItemId": "li-1", "ino": "12345"}"#.utf8)
        )
        #expect(started.ino == "12345")

        let progress = try JSONDecoder().decode(
            TrackProgressEvent.Schema.self,
            from: Data(#"{"libraryItemId": "li-1", "ino": "12345", "progress": 10}"#.utf8)
        )
        #expect(progress.progress == 10)

        let finished = try JSONDecoder().decode(
            TrackFinishedEvent.Schema.self,
            from: Data(#"{"libraryItemId": "li-1", "ino": "12345"}"#.utf8)
        )
        #expect(finished.libraryItemId == "li-1")
    }

    @Test
    func userItemProgressUpdatedCarriesSessionContext() throws {
        let data = Data(
            """
            {
              "id": "progress-1",
              "sessionId": "session-1",
              "deviceDescription": "iPhone",
              "data": { "id": "progress-1", "userId": "user-1", "libraryItemId": "li-1",
                "mediaItemId": "mi-1", "mediaItemType": "book", "duration": 60, "progress": 0.5,
                "currentTime": 30, "isFinished": false, "hideFromContinueListening": false,
                "lastUpdate": 2, "startedAt": 1 }
            }
            """.utf8
        )
        let payload = try JSONDecoder().decode(UserItemProgressUpdated.Schema.self, from: data)
        #expect(payload.sessionId == "session-1")
        #expect(payload.deviceDescription == "iPhone")
        #expect(payload.data.currentTime == 30)
    }

    @Test
    func customMetadataProviderRemovedCarriesTheProvider() throws {
        let data = Data(
            #"{"id": "p-1", "name": "Custom", "mediaType": "book", "slug": "custom-p-1"}"#.utf8
        )
        let payload = try JSONDecoder().decode(CustomMetadataProviderRemovedEvent.Schema.self, from: data)
        #expect(payload.id == "p-1")
    }

    @Test
    func initEventDecodesWithoutLibrariesScanning() throws {
        // The server never sends a librariesScanning key; requiring it broke every decode
        let data = Data(#"{"userId": "user-1", "username": "listener"}"#.utf8)
        let payload = try JSONDecoder().decode(InitEvent.Schema.self, from: data)
        #expect(payload.userId == "user-1")
        #expect(payload.usersOnline == nil)
    }

    private let publicUserJSON = """
    { "id": "user-1", "username": "listener", "type": "user", "session": null,
      "lastSeen": 1737600000000, "createdAt": 1737000000000, "connections": 2 }
    """

}
