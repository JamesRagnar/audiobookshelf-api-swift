import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct ListeningSessionContractTests {

    @Test
    func responseDecodesCurrentPaginationKeys() throws {
        let body = Data(
            """
            {
              "total": 0,
              "numPages": 0,
              "page": 0,
              "itemsPerPage": 10,
              "sessions": []
            }
            """.utf8
        )

        let decoded = try GetItemListeningSessions.handle(
            (data: body, response: makeResponse())
        )

        #expect(decoded.total == 0)
        #expect(decoded.numPages == 0)
        #expect(decoded.page == 0)
        #expect(decoded.itemsPerPage == 10)
        #expect(decoded.sessions.isEmpty)
    }

    @Test
    func requestEncodesItemAndPagination() {
        let request = GetItemListeningSessions.Request(
            libraryItemId: "library-item-id",
            episodeId: nil,
            itemsPerPage: 25,
            page: 2
        )

        #expect(request.path == "/api/me/item/listening-sessions/library-item-id")
        #expect(request.queryItems?["itemsPerPage"] == "25")
        #expect(request.queryItems?["page"] == "2")
    }

    private func makeResponse() throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))
    }

}
