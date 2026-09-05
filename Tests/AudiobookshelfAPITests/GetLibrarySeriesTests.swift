import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct GetLibrarySeriesTests {

    @Test
    func requestRequiresLimitAndAllowsOptionalPage() {
        let request = GetLibrarySeries.Request(libraryID: "lib-1", limit: 100)

        #expect(request.queryItems?["limit"] == "100")
        #expect(request.queryItems?["page"] == nil)
    }

    @Test
    func responseDecodesRequiredPaginationFields() throws {
        let body = Data(#"{"results":[],"total":0,"limit":100,"page":0,"sortBy":"name","sortDesc":false,"filterBy":null,"minified":false,"include":""}"#.utf8)
        let response = try GetLibrarySeries.handle((data: body, response: makeResponse()))

        #expect(response.results.isEmpty)
        #expect(response.total == 0)
        #expect(response.limit == 100)
        #expect(response.page == 0)
        #expect(response.sortDesc == false)
        #expect(response.minified == false)
        #expect(response.include.isEmpty)
    }

    private func makeResponse() throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
    }

}
