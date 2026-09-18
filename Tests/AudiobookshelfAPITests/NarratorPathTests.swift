import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct NarratorPathTests {

    @Test(arguments: [
        ("ÿ?", "w78_"),
        ("ñ>", "w7E-"),
        ("A", "QQ=="),
        ("李", "5p2O")
    ])
    func mutationPathsKeepNarratorAsOneURLSegment(name: String, encoded: String) throws {
        let update = UpdateLibraryNarrator.Request(libraryId: "library", narratorName: name, newName: "new")
        let remove = RemoveLibraryNarrator.Request(libraryId: "library", narratorName: name)
        let baseURL = try #require(URL(string: "https://example.com/abs/"))
        let configuration = ServerConfiguration(url: baseURL)
        let context = RequestContext(configuration: configuration, credential: "token")

        let updateURL = try URLRequest(interfaceRequest: update, context: context).url
        let removeURL = try URLRequest(interfaceRequest: remove, context: context).url
        #expect(updateURL?.absoluteString.hasSuffix("/abs/api/libraries/library/narrators/\(encoded)") == true)
        #expect(removeURL?.absoluteString.hasSuffix("/abs/api/libraries/library/narrators/\(encoded)") == true)
    }

}
