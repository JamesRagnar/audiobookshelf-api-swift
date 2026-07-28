//
//  AudioTrack.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct AudioTrack {

    /// The index of the audio track.
    public let index: Int

    /// When in the audio file (in seconds) the track starts.
    ///
    /// - Warning: This value is unreliable for every track that follows one with a null
    ///   ``duration``. The server accumulates offsets with `startOffset += track.duration`, and a
    ///   null contributes zero, so the null track and the one after it report the same offset. See
    ///   ``duration`` for how to handle it.
    public let startOffset: Float

    /// The length (in seconds) of the audio track. Null when ffprobe could not report one for the
    /// source audio file.
    ///
    /// A null here is a server-side data defect, not a transient condition. The scanner accepts any
    /// file with a readable audio stream, and does not require a duration, so the value persists
    /// until the file is re-scanned or re-encoded.
    ///
    /// It also corrupts the surrounding item: the containing media's total duration silently
    /// excludes this track, and every later track's ``startOffset`` is shifted earlier by this
    /// track's real length.
    ///
    /// Treating a null as zero reproduces that corruption in the client and hides it. Prefer to
    /// refuse playback when a null-duration track is followed by another track, since no correct
    /// timeline can be built. When the null is on the only track or the last one, the offsets that
    /// matter are intact and the real duration can be read from the decoded asset instead.
    public let duration: Float?

    /// The filename of the audio file the audio track belongs to.
    public let title: String

    /// The URL path of the audio file.
    public let contentUrl: String

    /// The MIME type of the audio file.
    public let mimeType: String

    /// The codec of the audio file.
    public let codec: String?

    /// The metadata of the audio file.
    public let metadata: FileMetadata?

}

extension AudioTrack: Decodable {}
extension AudioTrack: Encodable {}
extension AudioTrack: Sendable {}
