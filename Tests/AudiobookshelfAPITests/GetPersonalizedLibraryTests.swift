import AudiobookshelfAPI
import Testing

@Suite
struct GetPersonalizedLibraryTests {

    @Test
    func requestEncodesLimitWithoutPage() {
        let request = GetPersonalizedLibrary.Request(libraryID: "lib-1", limit: 5)

        #expect(request.queryItems?["limit"] == "5")
        #expect(request.queryItems?["page"] == nil)
    }

}
