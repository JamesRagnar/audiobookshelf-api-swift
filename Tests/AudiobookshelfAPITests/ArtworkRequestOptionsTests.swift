import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct ArtworkRequestOptionsTests {

    // MARK: GetLibraryItemCover

    @Test
    func libraryItemCoverPathIncludesItemID() {
        let params = GetLibraryItemCover.Request(itemID: "item-1")
        #expect(params.path == "/api/items/item-1/cover")
    }

    @Test
    func libraryItemCoverNoOptionsProducesNoQueryItems() {
        let params = GetLibraryItemCover.Request(itemID: "item-1")
        let items = params.queryItems ?? []
        #expect(items.isEmpty)
    }

    @Test
    func libraryItemCoverRawFalseOmitsRawQueryItem() {
        let params = GetLibraryItemCover.Request(itemID: "item-1", raw: false)
        #expect(params.queryItems?["raw"] == nil)
    }

    @Test
    func libraryItemCoverRawTrueEncodesAsOne() {
        let params = GetLibraryItemCover.Request(itemID: "item-1", raw: true)
        #expect(params.queryItems?["raw"] == "1")
    }

    @Test
    func libraryItemCoverEncodesAllOptions() {
        let params = GetLibraryItemCover.Request(
            itemID: "item-1",
            width: 200,
            height: 300,
            format: .webp,
            raw: true,
            timestamp: 12345
        )
        #expect(params.queryItems?["width"] == "200")
        #expect(params.queryItems?["height"] == "300")
        #expect(params.queryItems?["format"] == "webp")
        #expect(params.queryItems?["raw"] == "1")
        #expect(params.queryItems?["ts"] == "12345")
    }

    @Test
    func libraryItemCoverIsUnauthenticated() {
        let params = GetLibraryItemCover.Request(itemID: "item-1")
        guard case .none = params.authentication else {
            Issue.record("Expected unauthenticated request")
            return
        }
    }

    @Test
    func libraryItemCoverOptionsInitMatchesFlatInit() {
        let options = ArtworkRequestOptions(width: 100, height: 150, format: .jpeg, timestamp: 42, raw: true)
        let params = GetLibraryItemCover.Request(itemID: "item-1", options: options)
        #expect(params.queryItems?["width"] == "100")
        #expect(params.queryItems?["height"] == "150")
        #expect(params.queryItems?["format"] == "jpeg")
        #expect(params.queryItems?["ts"] == "42")
        #expect(params.queryItems?["raw"] == "1")
    }

    // MARK: GetAuthorImage

    @Test
    func authorImagePathIncludesAuthorID() {
        let params = GetAuthorImage.Request(authorID: "author-1")
        #expect(params.path == "/api/authors/author-1/image")
    }

    @Test
    func authorImageNoOptionsProducesNoQueryItems() {
        let params = GetAuthorImage.Request(authorID: "author-1")
        let items = params.queryItems ?? []
        #expect(items.isEmpty)
    }

    @Test
    func authorImageRawFalseOmitsRawQueryItem() {
        let params = GetAuthorImage.Request(authorID: "author-1", raw: false)
        #expect(params.queryItems?["raw"] == nil)
    }

    @Test
    func authorImageRawTrueEncodesAsOne() {
        let params = GetAuthorImage.Request(authorID: "author-1", raw: true)
        #expect(params.queryItems?["raw"] == "1")
    }

    @Test
    func authorImageEncodesAllOptions() {
        let params = GetAuthorImage.Request(
            authorID: "author-1",
            width: 200,
            height: 300,
            format: .webp,
            raw: true,
            timestamp: 12345
        )
        #expect(params.queryItems?["width"] == "200")
        #expect(params.queryItems?["height"] == "300")
        #expect(params.queryItems?["format"] == "webp")
        #expect(params.queryItems?["raw"] == "1")
        #expect(params.queryItems?["ts"] == "12345")
    }

    @Test
    func authorImageIsUnauthenticated() {
        let params = GetAuthorImage.Request(authorID: "author-1")
        guard case .none = params.authentication else {
            Issue.record("Expected unauthenticated request")
            return
        }
    }

    // MARK: ArtworkRequestOptions

    @Test
    func artworkRequestOptionsDefaultIsEmpty() {
        let options = ArtworkRequestOptions()
        #expect(options.width == nil)
        #expect(options.height == nil)
        #expect(options.format == nil)
        #expect(options.timestamp == nil)
        #expect(options.raw == nil)
    }

}
