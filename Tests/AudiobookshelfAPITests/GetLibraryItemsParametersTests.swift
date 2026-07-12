import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct GetLibraryItemsParametersTests {

    // MARK: Path

    @Test
    func pathIncludesLibraryID() {
        let params = GetLibraryItems.Parameters(libraryID: "lib-abc")
        #expect(params.path == "/api/libraries/lib-abc/items")
    }

    // MARK: No optional params → empty query dict (no nil-keyed entries)

    @Test
    func noOptionalParamsProducesNoQueryItems() {
        let params = GetLibraryItems.Parameters(libraryID: "lib-1")
        let items = params.queryItems ?? []
        #expect(items["limit"] == nil)
        #expect(items["page"] == nil)
        #expect(items["sort"] == nil)
        #expect(items["desc"] == nil)
        #expect(items["filter"] == nil)
        #expect(items["minified"] == nil)
        #expect(items["collapseseries"] == nil)
        #expect(items["include"] == nil)
    }

    // MARK: Pagination

    @Test
    func limitAndPageEncode() {
        let params = GetLibraryItems.Parameters(libraryID: "lib-1", limit: 25, page: 3)
        #expect(params.queryItems?["limit"] == "25")
        #expect(params.queryItems?["page"] == "3")
    }

    // MARK: Sort

    @Test
    func sortEncodes() {
        let params = GetLibraryItems.Parameters(libraryID: "lib-1", sort: "media.metadata.title")
        #expect(params.queryItems?["sort"] == "media.metadata.title")
    }

    @Test
    func descendingTrueEncodes() {
        let params = GetLibraryItems.Parameters(libraryID: "lib-1", descending: true)
        #expect(params.queryItems?["desc"] == "1")
    }

    @Test
    func descendingFalseEncodes() {
        let params = GetLibraryItems.Parameters(libraryID: "lib-1", descending: false)
        #expect(params.queryItems?["desc"] == "0")
    }

    // MARK: Filter

    @Test
    func filterEncodes() {
        let params = GetLibraryItems.Parameters(libraryID: "lib-1", filter: "genres.Fantasy")
        #expect(params.queryItems?["filter"] == "genres.Fantasy")
    }

    // MARK: Minified / collapseSeries

    @Test
    func minifiedTrueEncodes() {
        let params = GetLibraryItems.Parameters(libraryID: "lib-1", minified: true)
        #expect(params.queryItems?["minified"] == "1")
    }

    @Test
    func collapseSeriesTrueEncodes() {
        let params = GetLibraryItems.Parameters(libraryID: "lib-1", collapseSeries: true)
        #expect(params.queryItems?["collapseseries"] == "1")
    }

    // MARK: Include

    @Test
    func singleIncludeEncodes() {
        let params = GetLibraryItems.Parameters(libraryID: "lib-1", include: [.rssfeed])
        #expect(params.queryItems?["include"] == "rssfeed")
    }

    // MARK: All params together

    @Test
    func allParamsEncode() {
        let params = GetLibraryItems.Parameters(
            libraryID: "lib-1",
            limit: 10,
            page: 1,
            sort: "addedAt",
            descending: true,
            filter: "progress.finished",
            minified: true,
            collapseSeries: false,
            include: [.rssfeed]
        )
        #expect(params.queryItems?["limit"] == "10")
        #expect(params.queryItems?["page"] == "1")
        #expect(params.queryItems?["sort"] == "addedAt")
        #expect(params.queryItems?["desc"] == "1")
        #expect(params.queryItems?["filter"] == "progress.finished")
        #expect(params.queryItems?["minified"] == "1")
        #expect(params.queryItems?["collapseseries"] == "0")
        #expect(params.queryItems?["include"] == "rssfeed")
    }

}
