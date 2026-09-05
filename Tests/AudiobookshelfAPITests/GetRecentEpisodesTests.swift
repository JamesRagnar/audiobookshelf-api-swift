import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct GetRecentEpisodesTests {

    @Test
    func requestSupportsOptionalPagination() {
        let request = GetRecentEpisodes.Request(libraryId: "lib-1", limit: 10, page: 1)

        #expect(request.queryItems?["limit"] == "10")
        #expect(request.queryItems?["page"] == "1")
    }

    @Test
    func responseHasNoTotal() throws {
        let body = Data(#"{"episodes":[],"limit":0,"page":0}"#.utf8)
        let response = try GetRecentEpisodes.handle((data: body, response: makeResponse()))

        #expect(response.episodes.isEmpty)
        #expect(response.limit == 0)
        #expect(response.page == 0)
    }

    private func makeResponse() throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
    }

}
