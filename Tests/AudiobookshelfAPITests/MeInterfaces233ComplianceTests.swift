import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct MeInterfaces233ComplianceTests {

    @Test(arguments: [400, 403, 404])
    func bookmarkEndpointsMapErrorStatusCodes(statusCode: Int) throws {
        try assertMappedError(CreateBookmark.self, statusCode: statusCode)
        try assertMappedError(UpdateBookmark.self, statusCode: statusCode)
        try assertMappedError(DeleteBookmark.self, statusCode: statusCode)
    }

    @Test(arguments: [403, 404])
    func getItemListeningSessionsMapsAccessAndNotFound(statusCode: Int) throws {
        try assertMappedError(GetItemListeningSessions.self, statusCode: statusCode)
    }

    @Test
    func removeMediaProgressMapsNotFound() throws {
        try assertMappedError(RemoveMediaProgress.self, statusCode: 404)
    }

    @Test(arguments: [400, 404])
    func patchMediaProgressMapsValidationAndNotFound(statusCode: Int) throws {
        try assertMappedError(PatchMediaProgress.self, statusCode: statusCode)
    }

    @Test
    func getItemListeningSessionsDecodesCurrentServerPaginationKeys() throws {
        let body = Data(
            """
            {
              "total": 0,
              "numPages": 0,
              "page": 0,
              "itemsPerPage": 10,
              "sessions": []
            }
            """.utf8
        )

        let decoded = try GetItemListeningSessions.handle(
            (data: body, response: makeResponse(statusCode: 200))
        )

        #expect(decoded.total == 0)
        #expect(decoded.numPages == 0)
        #expect(decoded.page == 0)
        #expect(decoded.itemsPerPage == 10)
        #expect(decoded.sessions.isEmpty)
    }

    @Test
    func getItemListeningSessionsParametersEncodePaginationQueryItems() {
        let parameters = GetItemListeningSessions.Request(
            libraryItemId: "library-item-id",
            episodeId: nil,
            itemsPerPage: 25,
            page: 2
        )

        #expect(parameters.path == "/api/me/item/listening-sessions/library-item-id")
        #expect(parameters.queryItems?["itemsPerPage"] == "25")
        #expect(parameters.queryItems?["page"] == "2")
    }

    private func assertMappedError<T: Interface>(
        _ interface: T.Type,
        statusCode: Int,
        body: Data = Data()
    ) throws {
        let error = try captureResponseError(for: interface, statusCode: statusCode, body: body)
        #expect(error?.statusCode == statusCode)
    }

    private func captureResponseError<T: Interface>(
        for interface: T.Type,
        statusCode: Int,
        body: Data = Data()
    ) throws -> ResponseError? {
        let response = try makeResponse(statusCode: statusCode)
        do {
            _ = try interface.handle((data: body, response: response))
            return nil
        } catch let error {
            return error
        }
    }

    private func makeResponse(statusCode: Int) throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        ))
    }

}
