import AudiobookshelfAPI
import Testing

@Suite
struct SearchChaptersTests {

    @Test
    func requestOmitsUnsupportedLimit() {
        let request = SearchChapters.Request(query: "chapter", libraryId: "lib-1")

        #expect(request.queryItems?["q"] == "chapter")
        #expect(request.queryItems?["libraryId"] == "lib-1")
        #expect(request.queryItems?["limit"] == nil)
    }

}
