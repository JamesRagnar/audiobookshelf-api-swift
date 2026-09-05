import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct GetAllSessionsTests {

    @Test
    func requestOmitsOptionalParametersByDefault() {
        let request = GetAllSessions.Request()

        #expect(request.queryItems == nil)
    }

    @Test
    func requestEncodesExplicitPagination() {
        let request = GetAllSessions.Request(page: 3, itemsPerPage: 50)

        #expect(request.queryItems?["page"] == "3")
        #expect(request.queryItems?["itemsPerPage"] == "50")
    }

    @Test
    func requestEncodesUserPaginationSortAndDirection() {
        let request = GetAllSessions.Request(
            user: "user-1",
            page: 3,
            itemsPerPage: 50,
            sort: .timeListening,
            descending: true
        )

        #expect(request.queryItems?["user"] == "user-1")
        #expect(request.queryItems?["page"] == "3")
        #expect(request.queryItems?["itemsPerPage"] == "50")
        #expect(request.queryItems?["sort"] == "timeListening")
        #expect(request.queryItems?["desc"] == "1")
    }

    @Test
    func responseAllowsOptionalUserId() throws {
        let body = Data(#"{"total":0,"numPages":0,"page":0,"itemsPerPage":10,"sessions":[]}"#.utf8)
        let response = try GetAllSessions.handle((data: body, response: makeResponse()))

        #expect(response.total == 0)
        #expect(response.numPages == 0)
        #expect(response.page == 0)
        #expect(response.itemsPerPage == 10)
        #expect(response.sessions.isEmpty)
        #expect(response.userId == nil)
    }

    private func makeResponse() throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
    }

}
