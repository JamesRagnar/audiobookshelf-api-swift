import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct SearchExternalBooksTests {

    @Test
    func emptySuccessfulResponseReturnsEmptyArray() throws {
        let url = try #require(URL(string: "https://example.invalid/api/search/books"))
        let response = try #require(HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        ))
        let results = try SearchExternalBooks.handle((data: Data("[]".utf8), response: response))

        #expect(results.isEmpty)
    }

}
