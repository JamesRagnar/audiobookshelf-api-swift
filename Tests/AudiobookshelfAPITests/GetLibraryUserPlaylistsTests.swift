import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct GetLibraryUserPlaylistsTests {

    @Test
    func requestSupportsUnpagedAndPagedForms() {
        let unpaged = GetLibraryUserPlaylists.Request(libraryID: "lib-1")
        let paged = GetLibraryUserPlaylists.Request(libraryID: "lib-1", limit: 25, page: 2)

        #expect(unpaged.queryItems == nil)
        #expect(paged.queryItems?["limit"] == "25")
        #expect(paged.queryItems?["page"] == "2")
    }

    @Test
    func responseDecodesRequiredPaginationFields() throws {
        let body = Data(#"{"results":[],"total":0,"limit":0,"page":0}"#.utf8)
        let response = try GetLibraryUserPlaylists.handle((data: body, response: makeResponse()))

        #expect(response.results.isEmpty)
        #expect(response.total == 0)
        #expect(response.limit == 0)
        #expect(response.page == 0)
    }

    private func makeResponse() throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
    }

}
