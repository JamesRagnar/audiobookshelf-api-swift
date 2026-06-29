import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct AudioTrackDecodingTests {

    @Test
    func decodesRequiredFields() throws {
        let track = try decode(minimalTrackJSON)

        #expect(track.index == 0)
        #expect(track.startOffset == 0.0)
        #expect(track.duration == 3600.0)
        #expect(track.title == "Chapter 01.mp3")
        #expect(track.contentUrl == "/api/items/li-1/file/audio.mp3")
        #expect(track.mimeType == "audio/mpeg")
    }

    @Test
    func optionalFieldsDefaultToNil() throws {
        let track = try decode(minimalTrackJSON)
        #expect(track.codec == nil)
        #expect(track.metadata == nil)
    }

    @Test
    func decodesNonZeroStartOffset() throws {
        let json = """
        {
          "index": 2,
          "startOffset": 7265.4,
          "duration": 3601.0,
          "title": "Chapter 03.mp3",
          "contentUrl": "/api/items/li-1/file/ch3.mp3",
          "mimeType": "audio/mpeg"
        }
        """
        let track = try decode(json)
        #expect(track.index == 2)
        #expect(track.startOffset == 7265.4)
    }

    @Test
    func decodesOptionalCodec() throws {
        let json = """
        {
          "index": 0,
          "startOffset": 0.0,
          "duration": 1800.0,
          "title": "track.mp3",
          "contentUrl": "/api/items/li-1/file/track.mp3",
          "mimeType": "audio/mpeg",
          "codec": "mp3"
        }
        """
        let track = try decode(json)
        #expect(track.codec == "mp3")
    }

    @Test
    func missingStartOffsetThrows() {
        let json = """
        {
          "index": 0,
          "duration": 3600.0,
          "title": "track.mp3",
          "contentUrl": "/api/items/li-1/file/track.mp3",
          "mimeType": "audio/mpeg"
        }
        """
        #expect(throws: (any Error).self) {
            try decode(json)
        }
    }

    // MARK: Helpers

    private func decode(_ json: String) throws -> AudioTrack {
        try JSONDecoder().decode(AudioTrack.self, from: Data(json.utf8))
    }

}

// MARK: Fixtures

private let minimalTrackJSON = """
{
  "index": 0,
  "startOffset": 0.0,
  "duration": 3600.0,
  "title": "Chapter 01.mp3",
  "contentUrl": "/api/items/li-1/file/audio.mp3",
  "mimeType": "audio/mpeg"
}
"""
