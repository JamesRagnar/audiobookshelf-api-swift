import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct GetLibraryAuthorsResponseTests {

    @Test
    func requestDefaultsToNameAscending() {
        let request = GetLibraryAuthors.Request(libraryID: "lib-1")

        #expect(request.queryItems?["sort"] == "name")
        #expect(request.queryItems?["desc"] == "0")
    }

    @Test
    func requestAddsPageZeroWhenOnlyLimitIsProvided() {
        let request = GetLibraryAuthors.Request(libraryID: "lib-1", limit: 25)

        #expect(request.queryItems?["limit"] == "25")
        #expect(request.queryItems?["page"] == "0")
    }

    @Test
    func requestOmitsPageWhenOnlyPageIsProvided() {
        let request = GetLibraryAuthors.Request(libraryID: "lib-1", page: 2)

        #expect(request.queryItems?["page"] == nil)
        #expect(request.queryItems?["sort"] == "name")
        #expect(request.queryItems?["desc"] == "0")
    }

    @Test
    func requestEncodesPaginationAndDirection() {
        let request = GetLibraryAuthors.Request(
            libraryID: "lib-1",
            limit: 25,
            page: 2,
            sort: .numBooks,
            descending: true
        )

        #expect(request.queryItems?["limit"] == "25")
        #expect(request.queryItems?["page"] == "2")
        #expect(request.queryItems?["sort"] == "numBooks")
        #expect(request.queryItems?["desc"] == "1")
    }

    @Test
    func responseDecodesUnpaginatedAuthors() throws {
        let body = Data(#"{"authors":[]}"#.utf8)
        let response = try GetLibraryAuthors.handle((data: body, response: makeResponse()))

        #expect(response.authors.isEmpty)
        #expect(response.total == nil)
        #expect(response.limit == nil)
        #expect(response.page == nil)
        #expect(response.sortBy == nil)
        #expect(response.sortDesc == nil)
    }

    @Test
    func responseDecodesPaginatedAuthors() throws {
        let body = Data(#"{"results":[],"total":0,"limit":25,"page":2,"sortBy":"name","sortDesc":false}"#.utf8)
        let response = try GetLibraryAuthors.handle((data: body, response: makeResponse()))

        #expect(response.authors.isEmpty)
        #expect(response.total == 0)
        #expect(response.limit == 25)
        #expect(response.page == 2)
        #expect(response.sortBy == "name")
        #expect(response.sortDesc == false)
    }

    private func makeResponse() throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
    }

}
