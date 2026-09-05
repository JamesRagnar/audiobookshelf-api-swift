import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct GetLibraryNarratorsTests {

    @Test
    func responseUsesNarratorsEnvelope() throws {
        let body = Data(#"{"narrators":[]}"#.utf8)
        let response = try GetLibraryNarrators.handle((data: body, response: makeResponse()))

        #expect(response.narrators.isEmpty)
    }

    private func makeResponse() throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
    }

}
