import AudiobookshelfAPI
import Testing

@Suite
struct GetLibraryItemsParametersTests {

    @Test
    func defaultRequestContainsOnlyLibraryPath() {
        let request = GetLibraryItems.Request(libraryID: "lib-1")

        #expect(request.path == "/api/libraries/lib-1/items")
        #expect(request.queryItems?.isEmpty == true)
    }

    @Test(arguments: [(true, "1"), (false, "0")])
    func booleanValuesUseBinaryEncoding(value: Bool, encoded: String) {
        let request = GetLibraryItems.Request(
            libraryID: "lib-1",
            descending: value,
            minified: value,
            collapseSeries: value
        )

        #expect(request.queryItems?["desc"] == encoded)
        #expect(request.queryItems?["minified"] == encoded)
        #expect(request.queryItems?["collapseseries"] == encoded)
    }

    @Test
    func completeRequestEncodesEveryOption() {
        let request = GetLibraryItems.Request(
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

        #expect(request.queryItems?["limit"] == "10")
        #expect(request.queryItems?["page"] == "1")
        #expect(request.queryItems?["sort"] == "addedAt")
        #expect(request.queryItems?["desc"] == "1")
        #expect(request.queryItems?["filter"] == "progress.finished")
        #expect(request.queryItems?["minified"] == "1")
        #expect(request.queryItems?["collapseseries"] == "0")
        #expect(request.queryItems?["include"] == "rssfeed")
    }

}
