import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

/// Regression tests for response and event shapes corrected against the audiobookshelf 2.36.0
/// server source. Each fixture below is the literal shape the server emits.
@Suite
struct ServerContractAuditTests {

    // MARK: Wrapped REST Responses

    @Test
    func batchGetLibraryItemsDecodesWrapper() throws {
        let body = Data(#"{"libraryItems": []}"#.utf8)
        let decoded = try BatchGetLibraryItems.handle((data: body, response: try makeResponse()))
        #expect(decoded.libraryItems.isEmpty)
    }

    @Test
    func reorderLibrariesDecodesWrapper() throws {
        let body = Data(#"{"libraries": []}"#.utf8)
        let decoded = try ReorderLibraries.handle((data: body, response: try makeResponse()))
        #expect(decoded.libraries.isEmpty)
    }

    @Test
    func getLibraryPodcastTitlesDecodesPodcastObjects() throws {
        let body = Data(
            """
            {
              "podcasts": [
                { "title": "Example", "itunesId": null, "libraryItemId": "li-1", "libraryId": "lib-1" }
              ]
            }
            """.utf8
        )
        let decoded = try GetLibraryPodcastTitles.handle((data: body, response: try makeResponse()))
        #expect(decoded.podcasts.count == 1)
        #expect(decoded.podcasts.first?.title == "Example")
        #expect(decoded.podcasts.first?.itunesId == nil)
        #expect(decoded.podcasts.first?.libraryItemId == "li-1")
    }

    @Test
    func downloadQueueResponsesDecodeTheirWrappers() throws {
        let libraryBody = Data(#"{"currentDownload": null, "queue": []}"#.utf8)
        let library = try GetLibraryEpisodeDownloadQueue.handle(
            (data: libraryBody, response: try makeResponse())
        )
        #expect(library.currentDownload == nil)
        #expect(library.queue.isEmpty)

        let podcastBody = Data(#"{"downloads": []}"#.utf8)
        let podcast = try GetPodcastDownloadQueue.handle(
            (data: podcastBody, response: try makeResponse())
        )
        #expect(podcast.downloads.isEmpty)
    }

    @Test
    func customMetadataProviderResponsesDecodeTheirWrappers() throws {
        let listBody = Data(#"{"providers": []}"#.utf8)
        let list = try GetCustomMetadataProviders.handle((data: listBody, response: try makeResponse()))
        #expect(list.providers.isEmpty)
    }

    @Test
    func updateUserDecodesSuccessAndUserWrapper() throws {
        let body = Data("{\"success\": true, \"user\": \(userJSON)}".utf8)
        let decoded = try UpdateUser.handle((data: body, response: try makeResponse()))
        #expect(decoded.success == true)
        #expect(decoded.user.id == "user-1")
    }

    @Test
    func createUserDecodesUserWrapper() throws {
        let body = Data("{\"user\": \(userJSON)}".utf8)
        let decoded = try CreateUser.handle((data: body, response: try makeResponse()))
        #expect(decoded.user.username == "listener")
    }

    @Test
    func getAllUsersDecodesUsersWrapper() throws {
        let body = Data("{\"users\": [\(userJSON)]}".utf8)
        let decoded = try GetAllUsers.handle((data: body, response: try makeResponse()))
        #expect(decoded.users.count == 1)
    }

    @Test
    func updateUserEReaderDevicesReturnsDevicesNotAUser() throws {
        let body = Data(
            """
            { "ereaderDevices": [{ "name": "Kindle", "email": "k@example.com",
              "availabilityOption": "adminOrUp", "users": [] }] }
            """.utf8
        )
        let decoded = try UpdateUserEReaderDevices.handle((data: body, response: try makeResponse()))
        #expect(decoded.ereaderDevices.first?.name == "Kindle")
    }

    @Test
    func createPodcastFromFeedReturnsParsedFeedNotALibraryItem() throws {
        let body = Data(
            """
            { "podcast": { "metadata": { "title": "Example", "categories": [], "image": null,
              "link": null }, "numEpisodes": 12 } }
            """.utf8
        )
        let decoded = try CreatePodcastFromFeed.handle((data: body, response: try makeResponse()))
        #expect(decoded.podcast.metadata.title == "Example")
        #expect(decoded.podcast.numEpisodes == 12)
    }

    @Test
    func updateAuthorDecodesMergedAndUpdatedVariants() throws {
        let updatedBody = Data("{\"author\": \(authorJSON), \"updated\": true}".utf8)
        let updatedResponse = try UpdateAuthor.handle((data: updatedBody, response: try makeResponse()))
        #expect(updatedResponse.updated == true)
        #expect(updatedResponse.merged == nil)

        let mergedBody = Data("{\"author\": \(authorJSON), \"merged\": true}".utf8)
        let mergedResponse = try UpdateAuthor.handle((data: mergedBody, response: try makeResponse()))
        #expect(mergedResponse.merged == true)
        #expect(mergedResponse.updated == nil)
    }

    @Test
    func getAllSessionsDecodesPagination() throws {
        let body = Data(
            #"{"total": 0, "numPages": 0, "page": 0, "itemsPerPage": 10, "sessions": []}"#.utf8
        )
        let decoded = try GetAllSessions.handle((data: body, response: try makeResponse()))
        #expect(decoded.total == 0)
        #expect(decoded.userId == nil)
    }

    @Test
    func getOpenSessionsSeparatesShareSessions() throws {
        let body = Data(#"{"sessions": [], "shareSessions": []}"#.utf8)
        let decoded = try GetOpenSessions.handle((data: body, response: try makeResponse()))
        #expect(decoded.sessions.isEmpty)
        #expect(decoded.shareSessions.isEmpty)
    }

    @Test
    func getOnlineUsersDecodesPublicUsers() throws {
        let body = Data(
            """
            { "usersOnline": [\(publicUserJSON)], "openSessions": [] }
            """.utf8
        )
        let decoded = try GetOnlineUsers.handle((data: body, response: try makeResponse()))
        #expect(decoded.usersOnline.first?.username == "listener")
        #expect(decoded.usersOnline.first?.connections == 2)
    }

    @Test
    func createAPIKeyExposesGeneratedKeyAlongsideRecord() throws {
        let body = Data(
            """
            { "apiKey": { "apiKey": "generated-secret", "id": "key-1", "name": "CI", "userId": "user-1",
              "isActive": true, "createdByUserId": "user-1", "createdAt": 1, "updatedAt": 2,
              "permissions": { "download": true, "update": false, "delete": false, "upload": false,
                "accessAllLibraries": true, "accessAllTags": true, "accessExplicitContent": true } } }
            """.utf8
        )
        let decoded = try CreateAPIKey.handle((data: body, response: try makeResponse()))
        #expect(decoded.apiKey.apiKey == "generated-secret")
        #expect(decoded.apiKey.details.id == "key-1")
        #expect(decoded.apiKey.details.name == "CI")
    }

    @Test
    func searchExternalAuthorsDecodesSingleResultAndNull() throws {
        let found = Data(#"{"asin": "B001", "name": "Someone", "description": null, "image": null}"#.utf8)
        let author = try SearchExternalAuthors.handle((data: found, response: try makeResponse()))
        #expect(author?.name == "Someone")

        // The server responds with a bare `null` when no author matched closely enough
        let missing = Data("null".utf8)
        let noAuthor = try SearchExternalAuthors.handle((data: missing, response: try makeResponse()))
        #expect(noAuthor == nil)
    }

    // MARK: Method Corrections

    @Test
    func applyBackupUsesGet() {
        #expect(ApplyBackup.Parameters(backupId: "b-1").method == .get)
        #expect(ApplyBackup.Parameters(backupId: "b-1").path == "/api/backups/b-1/apply")
    }

    // MARK: Fixtures

    private let userJSON = """
    { "id": "user-1", "username": "listener", "type": "user", "isActive": true, "isLocked": false,
      "lastSeen": 1737600000000, "createdAt": 1737000000000, "seriesHideFromContinueListening": [],
      "permissions": { "download": true, "update": false, "delete": false, "upload": false,
        "accessAllLibraries": true, "accessAllTags": true, "accessExplicitContent": true },
      "librariesAccessible": [], "itemTagsSelected": [] }
    """

    private let publicUserJSON = """
    { "id": "user-1", "username": "listener", "type": "user", "session": null,
      "lastSeen": 1737600000000, "createdAt": 1737000000000, "connections": 2 }
    """

    private let authorJSON = """
    { "id": "author-1", "name": "Someone", "libraryId": "lib-1" }
    """

    private func makeResponse(statusCode: Int = 200) throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        ))
    }

}
