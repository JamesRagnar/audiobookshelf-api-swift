@testable import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct LocalSessionSyncContractsTests {

    @Test
    func localPlaybackSessionEncodingIncludesSessionId() throws {
        let payload = SyncLocalSession.Parameters.LocalPlaybackSession(
            id: "session-1",
            libraryItemId: "item-1",
            mediaType: "book",
            duration: 3600,
            currentTime: 120,
            startTime: 0,
            timeListening: 120,
            startedAt: 1000,
            updatedAt: 2000
        )

        let encoded = try JSONEncoder().encode(payload)
        let object = try #require(
            JSONSerialization.jsonObject(with: encoded) as? [String: Any]
        )

        #expect(object["id"] as? String == "session-1")
        #expect(object["libraryItemId"] as? String == "item-1")
    }

    @Test
    func syncBatchResponseDecodingStillRequiresId() throws {
        let validJSON = """
        {
          "results": [
            {
              "id": "session-1",
              "success": true,
              "progressSynced": true,
              "error": null
            }
          ]
        }
        """

        let validResponse = try JSONDecoder().decode(
            SyncLocalSessionsBatch.Response.self,
            from: Data(validJSON.utf8)
        )
        #expect(validResponse.results.count == 1)
        #expect(validResponse.results.first?.id == "session-1")

        let invalidJSON = """
        {
          "results": [
            {
              "success": true,
              "progressSynced": true,
              "error": null
            }
          ]
        }
        """

        do {
            _ = try JSONDecoder().decode(
                SyncLocalSessionsBatch.Response.self,
                from: Data(invalidJSON.utf8)
            )
            #expect(Bool(false))
        } catch {
            #expect(Bool(true))
        }
    }

}
