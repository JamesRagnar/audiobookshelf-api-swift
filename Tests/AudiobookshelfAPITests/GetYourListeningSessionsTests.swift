import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct GetYourListeningSessionsTests {

    @Test
    func requestAllowsServerDefaults() {
        let request = GetYourListeningSessions.Request()

        #expect(request.queryItems == nil)
    }

    @Test
    func requestEncodesExplicitPagination() {
        let request = GetYourListeningSessions.Request(itemsPerPage: 25, page: 2)

        #expect(request.queryItems?["itemsPerPage"] == "25")
        #expect(request.queryItems?["page"] == "2")
    }

    @Test
    func responseDecodesRequiredPaginationFields() throws {
        let body = Data(#"{"total":0,"numPages":0,"page":0,"itemsPerPage":10,"sessions":[]}"#.utf8)
        let response = try GetYourListeningSessions.handle((data: body, response: makeResponse()))

        #expect(response.total == 0)
        #expect(response.numPages == 0)
        #expect(response.page == 0)
        #expect(response.itemsPerPage == 10)
        #expect(response.sessions.isEmpty)
    }

    private func makeResponse() throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
    }

}
