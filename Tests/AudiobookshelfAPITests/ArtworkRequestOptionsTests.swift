import AudiobookshelfAPI
import Testing

@Suite
struct ArtworkRequestOptionsTests {

    @Test
    func defaultsProduceNoQueryItems() {
        #expect(GetLibraryItemCover.Request(itemID: "item-1").queryItems?.isEmpty == true)
        #expect(GetAuthorImage.Request(authorID: "author-1").queryItems?.isEmpty == true)
    }

    @Test
    func falseRawValueIsOmitted() {
        #expect(GetLibraryItemCover.Request(itemID: "item-1", raw: false).queryItems?["raw"] == nil)
        #expect(GetAuthorImage.Request(authorID: "author-1", raw: false).queryItems?["raw"] == nil)
    }

    @Test
    func libraryItemCoverEncodesCompleteRequest() {
        let request = GetLibraryItemCover.Request(
            itemID: "item-1",
            width: 200,
            height: 300,
            format: .webp,
            raw: true,
            timestamp: 12345
        )

        #expect(request.path == "/api/items/item-1/cover")
        #expect(request.queryItems?["width"] == "200")
        #expect(request.queryItems?["height"] == "300")
        #expect(request.queryItems?["format"] == "webp")
        #expect(request.queryItems?["raw"] == "1")
        #expect(request.queryItems?["ts"] == "12345")
        #expect(request.authentication == .none)
    }

    @Test
    func authorImageEncodesSharedOptions() {
        let options = ArtworkRequestOptions(
            width: 100,
            height: 150,
            format: .jpeg,
            timestamp: 42,
            raw: true
        )
        let request = GetAuthorImage.Request(authorID: "author-1", options: options)

        #expect(request.path == "/api/authors/author-1/image")
        #expect(request.queryItems?["width"] == "100")
        #expect(request.queryItems?["height"] == "150")
        #expect(request.queryItems?["format"] == "jpeg")
        #expect(request.queryItems?["raw"] == "1")
        #expect(request.queryItems?["ts"] == "42")
        #expect(request.authentication == .none)
    }

}
