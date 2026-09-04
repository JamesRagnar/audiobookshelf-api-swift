import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct PaginationResponseContractTests {

    @Test
    func recentEpisodesDecodeServerResponseWithoutTotal() throws {
        let body = Data(#"{"episodes":[],"limit":10,"page":0}"#.utf8)

        let response = try GetRecentEpisodes.handle((data: body, response: makeResponse()))

        #expect(response.episodes.isEmpty)
        #expect(response.limit == 10)
        #expect(response.page == 0)
    }

    @Test
    func userListeningSessionsDecodeAllPaginationFields() throws {
        let body = Data(
            #"{"total":0,"numPages":0,"page":0,"itemsPerPage":10,"sessions":[]}"#.utf8
        )

        let response = try GetUserListeningSessions.handle((data: body, response: makeResponse()))

        #expect(response.total == 0)
        #expect(response.numPages == 0)
        #expect(response.page == 0)
        #expect(response.itemsPerPage == 10)
        #expect(response.sessions.isEmpty)
    }

    @Test
    func currentUserListeningSessionsDecodePage() throws {
        let body = Data(
            #"{"total":0,"numPages":0,"page":0,"itemsPerPage":10,"sessions":[]}"#.utf8
        )

        let response = try GetYourListeningSessions.handle((data: body, response: makeResponse()))

        #expect(response.total == 0)
        #expect(response.numPages == 0)
        #expect(response.page == 0)
        #expect(response.itemsPerPage == 10)
        #expect(response.sessions.isEmpty)
    }

    private func makeResponse() throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))
    }

}
