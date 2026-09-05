import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct GetLibraryItemsResponseTests {

    @Test
    func responseDecodesRequiredPaginationAndOptions() throws {
        let body = Data(#"{"results":[],"total":0,"limit":0,"page":0,"sortBy":null,"sortDesc":false,"filterBy":null,"mediaType":"book","minified":false,"collapseseries":false,"include":""}"#.utf8)
        let response = try GetLibraryItems.handle((data: body, response: makeResponse()))

        #expect(response.results.isEmpty)
        #expect(response.total == 0)
        #expect(response.limit == 0)
        #expect(response.page == 0)
        #expect(response.sortDesc == false)
        #expect(response.mediaType == .book)
        #expect(response.minified == false)
        #expect(response.collapseseries == false)
        #expect(response.include.isEmpty)
    }

    private func makeResponse() throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
    }

}
