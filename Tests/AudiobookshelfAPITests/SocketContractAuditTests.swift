import AudiobookshelfAPI
import Foundation
import RagnarSocketIO
import Testing

/// Socket event payload shapes corrected against the audiobookshelf 2.36.0 server source.
@Suite
struct SocketContractAuditTests {

    @Test
    func clientEventsAreEmittableContracts() {
        requireEmittable(AuthEvent.self)
        requireEmittable(CancelScanEvent.self)
        requireEmittable(SetLogListenerEvent.self)
        requireEmittable(RemoveLogListenerEvent.self)
        requireEmittable(MessageAllUsersEvent.self)
        requireEmittable(PingEvent.self)
        requireEmittable(SearchCoversEvent.self)
        requireEmittable(CancelCoverSearchEvent.self)
    }

    @Test
    func serverEventsAreNotEmittableContracts() {
        #expect(!(ItemAddedEvent.self is any EmittableSocketEvent.Type))
        #expect(!(InitEvent.self is any EmittableSocketEvent.Type))
        #expect(!(StreamReadyEvent.self is any EmittableSocketEvent.Type))
    }

    @Test
    func clientEventEncodingUsesDefaultArgumentShapes() throws {
        let scalar = try AuthEvent.encode("token", using: JSONEncoder())
        let object = try SearchCoversEvent.encode(
            .init(
                requestId: "request-1",
                title: "Book",
                author: "Author",
                provider: "google",
                podcast: false
            ),
            using: JSONEncoder()
        )
        let empty = try PingEvent.encode(SocketEmptyBody(), using: JSONEncoder())

        #expect(scalar.count == 1)
        #expect(object.count == 1)
        #expect(empty.isEmpty)
    }

    @Test
    func emptyServerEventsAcceptZeroArgumentsOrNull() throws {
        _ = try BackupAppliedEvent.decode(arguments: [], using: JSONDecoder())
        _ = try BackupAppliedEvent.decode(arguments: [.null], using: JSONDecoder())
        _ = try StreamReadyEvent.decode(arguments: [], using: JSONDecoder())
        _ = try StreamReadyEvent.decode(arguments: [.null], using: JSONDecoder())
    }

    @Test
    func streamPoliciesMatchDeliverySemantics() {
        #expect(InitEvent.defaultStreamPolicy == .latest)
        #expect(NotificationsUpdatedEvent.defaultStreamPolicy == .latest)
        #expect(EReaderDevicesUpdatedEvent.defaultStreamPolicy == .latest)
        #expect(LogEvent.defaultStreamPolicy == .latest)

        #expect(ItemsUpdatedEvent.defaultStreamPolicy == .bounded)
        #expect(TaskProgress.defaultStreamPolicy == .bounded)
        #expect(TrackProgressEvent.defaultStreamPolicy == .bounded)
        #expect(StreamProgressEvent.defaultStreamPolicy == .bounded)
        #expect(UserItemProgressUpdated.defaultStreamPolicy == .bounded)
    }

    @Test
    func eventNamesAreUnique() {
        let names = [
            AdminMessageEvent.name,
            AuthEvent.name,
            AuthorAddedEvent.name,
            AuthorRemovedEvent.name,
            AuthorUpdatedEvent.name,
            AuthorsNumBooksUpdatedEvent.name,
            BackupAppliedEvent.name,
            BatchQuickMatchCompleteEvent.name,
            CancelCoverSearchEvent.name,
            CancelScanEvent.name,
            CollectionAddedEvent.name,
            CollectionRemovedEvent.name,
            CollectionUpdatedEvent.name,
            CoverSearchCancelled.name,
            CoverSearchComplete.name,
            CoverSearchError.name,
            CoverSearchProviderError.name,
            CoverSearchResult.name,
            CustomMetadataProviderAddedEvent.name,
            CustomMetadataProviderRemovedEvent.name,
            EReaderDevicesUpdatedEvent.name,
            EpisodeAddedEvent.name,
            EpisodeDownloadFinishedEvent.name,
            EpisodeDownloadQueueClearedEvent.name,
            EpisodeDownloadQueuedEvent.name,
            EpisodeDownloadStartedEvent.name,
            InitEvent.name,
            ItemAddedEvent.name,
            ItemRemovedEvent.name,
            ItemUpdatedEvent.name,
            ItemsAddedEvent.name,
            ItemsUpdatedEvent.name,
            LibraryAddedEvent.name,
            LibraryRemovedEvent.name,
            LibraryUpdatedEvent.name,
            LogEvent.name,
            MessageAllUsersEvent.name,
            MetadataEmbedQueueUpdate.name,
            NotificationsUpdatedEvent.name,
            PingEvent.name,
            PlaylistAddedEvent.name,
            PlaylistRemovedEvent.name,
            PlaylistUpdatedEvent.name,
            PongEvent.name,
            RemoveLogListenerEvent.name,
            RssFeedClosedEvent.name,
            RssFeedOpenEvent.name,
            SearchCoversEvent.name,
            SeriesAddedEvent.name,
            SeriesRemovedEvent.name,
            SeriesUpdatedEvent.name,
            SetLogListenerEvent.name,
            ShareClosedEvent.name,
            ShareOpenEvent.name,
            StreamClosedEvent.name,
            StreamErrorEvent.name,
            StreamOpenEvent.name,
            StreamProgressEvent.name,
            StreamReadyEvent.name,
            StreamResetEvent.name,
            TaskFinished.name,
            TaskProgress.name,
            TaskStarted.name,
            TrackFinishedEvent.name,
            TrackProgressEvent.name,
            TrackStartedEvent.name,
            UserAddedEvent.name,
            UserItemProgressUpdated.name,
            UserOfflineEvent.name,
            UserOnlineEvent.name,
            UserRemovedEvent.name,
            UserSessionClosedEvent.name,
            UserStreamUpdateEvent.name,
            UserUpdatedEvent.name
        ]

        #expect(Set(names).count == names.count)
    }

    private func requireEmittable<Event: EmittableSocketEvent>(_ event: Event.Type) {}
}

extension SocketContractAuditTests {

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

    // The stream events are emitted through a `clientEmit` wrapper rather than a direct
    // `SocketAuthority` call, which makes them easy to miss when grepping the server source.

    @Test
    func streamErrorCarriesIdAndMessage() throws {
        let data = Data(#"{"id": "stream-1", "error": "ffmpeg exited with code 1"}"#.utf8)
        let payload = try JSONDecoder().decode(StreamErrorEvent.Schema.self, from: data)
        #expect(payload.id == "stream-1")
        #expect(payload.error == "ffmpeg exited with code 1")
    }

    @Test
    func streamClosedIsABareIdString() throws {
        let payload = try JSONDecoder().decode(
            StreamClosedEvent.Schema.self,
            from: Data(#""stream-1""#.utf8)
        )
        #expect(payload == "stream-1")
    }

    @Test
    func streamProgressDecodesTranscodeProgress() throws {
        let data = Data(
            #"{"stream": "stream-1", "percent": "42%", "chunks": ["0-5"], "numSegments": 12}"#.utf8
        )
        let payload = try JSONDecoder().decode(StreamProgressEvent.Schema.self, from: data)
        #expect(payload.stream == "stream-1")
        #expect(payload.percent == "42%")
        #expect(payload.numSegments == 12)
    }

    @Test
    func streamResetCarriesStreamIdNotId() throws {
        let data = Data(#"{"startTime": 120.5, "streamId": "stream-1"}"#.utf8)
        let payload = try JSONDecoder().decode(StreamResetEvent.Schema.self, from: data)
        #expect(payload.streamId == "stream-1")
        #expect(payload.startTime == 120.5)
    }

    private var publicUserJSON: String {
        """
        { "id": "user-1", "username": "listener", "type": "user", "session": null,
          "lastSeen": 1737600000000, "createdAt": 1737000000000, "connections": 2 }
        """
    }

}
