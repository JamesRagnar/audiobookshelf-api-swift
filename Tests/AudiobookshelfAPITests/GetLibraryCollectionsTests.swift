import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct GetLibraryCollectionsTests {

    @Test
    func requestDoesNotSerializeUnsupportedSortOrFilter() {
        let request = GetLibraryCollections.Request(libraryID: "lib-1", limit: 25, page: 1)

        #expect(request.queryItems?["limit"] == "25")
        #expect(request.queryItems?["page"] == "1")
        #expect(request.queryItems?["sort"] == nil)
        #expect(request.queryItems?["filter"] == nil)
    }

    @Test
    func responseDecodesWithoutNumPages() throws {
        let body = Data(#"{"results":[],"total":0,"limit":0,"page":0,"sortDesc":false,"minified":false,"include":""}"#.utf8)
        let response = try GetLibraryCollections.handle((data: body, response: makeResponse()))

        #expect(response.results.isEmpty)
        #expect(response.total == 0)
        #expect(response.limit == 0)
        #expect(response.page == 0)
        #expect(response.sortBy == nil)
        #expect(response.filterBy == nil)
    }

    private func makeResponse() throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
    }

}
