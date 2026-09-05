import AudiobookshelfAPI
import Testing

@Suite
struct SearchLibraryTests {

    @Test
    func requestEncodesLimitWithoutPage() {
        let request = SearchLibrary.Request(libraryID: "lib-1", query: "query", limit: 10)

        #expect(request.queryItems?["limit"] == "10")
        #expect(request.queryItems?["page"] == nil)
    }

}
