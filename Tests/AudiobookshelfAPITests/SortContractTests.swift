import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct SortContractTests {

    @Test(arguments: [
        (GetLibrarySeries.Request.Sort.numBooks, "numBooks"),
        (.totalDuration, "totalDuration"),
        (.addedAt, "addedAt"),
        (.name, "name"),
        (.lastBookAdded, "lastBookAdded"),
        (.lastBookUpdated, "lastBookUpdated"),
        (.random, "random")
    ])
    func seriesSortUsesServerRawValue(sort: GetLibrarySeries.Request.Sort, rawValue: String) {
        let request = GetLibrarySeries.Request(libraryID: "lib-1", limit: 10, sort: sort)

        #expect(request.queryItems?["sort"] == rawValue)
    }

    @Test(arguments: [
        (GetLibraryAuthors.Request.Sort.name, "name"),
        (.lastFirst, "lastFirst"),
        (.addedAt, "addedAt"),
        (.updatedAt, "updatedAt"),
        (.numBooks, "numBooks")
    ])
    func authorSortUsesServerRawValue(sort: GetLibraryAuthors.Request.Sort, rawValue: String) {
        let request = GetLibraryAuthors.Request(libraryID: "lib-1", sort: sort)

        #expect(request.queryItems?["sort"] == rawValue)
    }

    @Test(arguments: [
        (GetAllSessions.Request.Sort.displayTitle, "displayTitle"),
        (.duration, "duration"),
        (.playMethod, "playMethod"),
        (.startTime, "startTime"),
        (.currentTime, "currentTime"),
        (.timeListening, "timeListening"),
        (.updatedAt, "updatedAt"),
        (.createdAt, "createdAt")
    ])
    func playbackSessionSortUsesServerRawValue(sort: GetAllSessions.Request.Sort, rawValue: String) {
        let request = GetAllSessions.Request(sort: sort)

        #expect(request.queryItems?["sort"] == rawValue)
    }

    @Test
    func authorRequestDefaultsToNameAscending() {
        let request = GetLibraryAuthors.Request(libraryID: "lib-1")

        #expect(request.queryItems?["sort"] == "name")
        #expect(request.queryItems?["desc"] == "0")
    }

    @Test
    func authorLimitDefaultsToFirstPage() {
        let request = GetLibraryAuthors.Request(libraryID: "lib-1", limit: 25)

        #expect(request.queryItems?["limit"] == "25")
        #expect(request.queryItems?["page"] == "0")
    }

    @Test
    func authorRequestEncodesPaginationAndDirection() {
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
    func authorsResponseDecodesPaginatedResults() throws {
        let body = Data(
            #"{"results":[{"id":"author-1","name":"Someone"}],"total":1,"limit":25,"page":2,"sortBy":"name","sortDesc":false}"#.utf8
        )

        let response = try GetLibraryAuthors.handle((data: body, response: makeResponse()))

        #expect(response.authors.first?.id == "author-1")
        #expect(response.total == 1)
        #expect(response.limit == 25)
        #expect(response.page == 2)
        #expect(response.sortBy == "name")
        #expect(response.sortDesc == false)
    }

    @Test
    func allSessionsOmitSortToPreserveServerDefault() {
        let request = GetAllSessions.Request()

        #expect(request.queryItems == nil)
    }

    @Test
    func allSessionsEncodeUserPaginationSortAndDirection() {
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
    func collectionRequestDoesNotAdvertiseUnsupportedSortOrFilter() {
        let request = GetLibraryCollections.Request(libraryID: "lib-1")

        #expect(request.queryItems?["sort"] == nil)
        #expect(request.queryItems?["filter"] == nil)
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
