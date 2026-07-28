import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

/// Status code mappings corrected against the audiobookshelf 2.36.0 handler chains, including the
/// controller middleware that runs before each handler.
@Suite
struct StatusCodeMappingAuditTests {

    // Codes contributed by controller middleware, verified against the 2.36.0 handler chains.
    // Without these the client gets an untyped `unknownResponseCase` instead of a typed error.

    @Test(arguments: [403, 404])
    func getLibraryItemMapsAccessAndNotFound(statusCode: Int) throws {
        try assertMappedError(GetLibraryItem.self, statusCode: statusCode)
    }

    @Test(arguments: [400, 403, 404])
    func libraryScopedGetsMapMiddlewareCodes(statusCode: Int) throws {
        try assertMappedError(GetLibraryItems.self, statusCode: statusCode)
        try assertMappedError(GetLibrary.self, statusCode: statusCode)
        try assertMappedError(GetPersonalizedLibrary.self, statusCode: statusCode)
        try assertMappedError(GetLibraryFilterData.self, statusCode: statusCode)
        try assertMappedError(GetLibrarySeries.self, statusCode: statusCode)
        try assertMappedError(GetRecentEpisodes.self, statusCode: statusCode)
        try assertMappedError(GetLibraryStats.self, statusCode: statusCode)
        try assertMappedError(SearchLibrary.self, statusCode: statusCode)
        try assertMappedError(GetLibraryEpisodeDownloadQueue.self, statusCode: statusCode)
        try assertMappedError(GetLibraryPodcastTitles.self, statusCode: statusCode)
    }

    @Test(arguments: [403, 404, 500])
    func podcastScopedGetsMapMiddlewareCodes(statusCode: Int) throws {
        try assertMappedError(GetPodcastDownloadQueue.self, statusCode: statusCode)
        try assertMappedError(UpdatePodcastEpisode.self, statusCode: statusCode)
    }

    @Test
    func batchGetLibraryItemsMapsForbidden() throws {
        try assertMappedError(BatchGetLibraryItems.self, statusCode: 403)
    }

    @Test(arguments: [400, 403, 404])
    func updateAuthorMapsValidationAccessAndNotFound(statusCode: Int) throws {
        try assertMappedError(UpdateAuthor.self, statusCode: statusCode)
    }

    @Test
    func sessionListsMapNotFoundForNonAdmins() throws {
        try assertMappedError(GetAllSessions.self, statusCode: 404)
        try assertMappedError(GetOpenSessions.self, statusCode: 404)
    }

    @Test
    func creationEndpointsMapInternalServerError() throws {
        try assertMappedError(CreateUser.self, statusCode: 500)
        try assertMappedError(CreateAPIKey.self, statusCode: 500)
        try assertMappedError(SearchExternalAuthors.self, statusCode: 500)
    }

    @Test
    func getLibraryItemCoverMapsBadRequestNotInternalError() throws {
        try assertMappedError(GetLibraryItemCover.self, statusCode: 400)
    }

    private func assertMappedError<T: Interface>(
        _ interface: T.Type,
        statusCode: Int,
        body: Data = Data()
    ) throws {
        let response = try makeResponse(statusCode: statusCode)
        do {
            _ = try interface.handle((data: body, response: response))
            Issue.record("\(interface) did not map status \(statusCode)")
        } catch let error {
            #expect(error.statusCode == statusCode)
        }
    }

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
