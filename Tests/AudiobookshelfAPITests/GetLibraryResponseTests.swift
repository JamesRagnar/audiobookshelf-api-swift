import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct GetLibraryResponseTests {

    @Test
    func directResponseDecodesLibrary() throws {
        let response = try decode(libraryJSON)

        #expect(response.library.id == "library-1")
        #expect(response.filterdata == nil)
        #expect(response.issues == nil)
        #expect(response.numUserPlaylists == nil)
    }

    @Test
    func expandedResponseDecodesWrapper() throws {
        let response = try decode(
            """
            {
              "library": \(libraryJSON),
              "filterdata": {
                "genres": ["Fiction"],
                "numIssues": 2,
                "loadedAt": 1000
              },
              "issues": 2,
              "numUserPlaylists": 3
            }
            """
        )

        #expect(response.library.id == "library-1")
        #expect(response.filterdata?.genres == ["Fiction"])
        #expect(response.issues == 2)
        #expect(response.numUserPlaylists == 3)
    }

    private func decode(_ json: String) throws -> GetLibrary.Response {
        try JSONDecoder().decode(GetLibrary.Response.self, from: Data(json.utf8))
    }

    private var libraryJSON: String {
        """
        {
          "id": "library-1",
          "name": "Books",
          "folders": [],
          "mediaType": "book",
          "settings": {
            "coverAspectRatio": 1,
            "disableWatcher": false
          },
          "createdAt": 100,
          "lastUpdate": 200
        }
        """
    }

}
