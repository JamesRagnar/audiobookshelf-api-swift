import AudiobookshelfAPI
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

}
