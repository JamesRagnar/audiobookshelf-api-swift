import AudiobookshelfAPI
import Testing

@Suite
struct NarratorPathTests {

    @Test(arguments: [
        ("ÿ?", "w78_"),
        ("ñ>", "w7E-"),
        ("A", "QQ=="),
        ("李", "5p2O")
    ])
    func mutationPathsKeepNarratorAsOneURLSegment(name: String, encoded: String) {
        #expect(UpdateLibraryNarrator.Request(libraryId: "library", narratorName: name, newName: "new").path ==
                "/api/libraries/library/narrators/\(encoded)")
        #expect(RemoveLibraryNarrator.Request(libraryId: "library", narratorName: name).path ==
                "/api/libraries/library/narrators/\(encoded)")
    }

}
