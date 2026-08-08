import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct AudioTrackDecodingTests {

    @Test
    func decodesRepresentativeServerPayload() throws {
        let track = try JSONDecoder().decode(
            AudioTrack.self,
            from: Data(
                """
                {
                  "index": 2,
                  "startOffset": 7265.4,
                  "duration": 3601.0,
                  "title": "Chapter 03.mp3",
                  "contentUrl": "/api/items/li-1/file/ch3.mp3",
                  "mimeType": "audio/mpeg",
                  "codec": "mp3"
                }
                """.utf8
            )
        )

        #expect(track.index == 2)
        #expect(track.startOffset == 7265.4)
        #expect(track.duration == 3601.0)
        #expect(track.contentUrl == "/api/items/li-1/file/ch3.mp3")
        #expect(track.codec == "mp3")
        #expect(track.metadata == nil)
    }

}
