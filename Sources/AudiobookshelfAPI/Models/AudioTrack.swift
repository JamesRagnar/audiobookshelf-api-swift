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
    /// - Warning: Unreliable for every track following one with a null ``duration``. The server
    ///   accumulates offsets with `startOffset += track.duration`, where a null adds zero.
    public let startOffset: Float

    /// The length (in seconds) of the audio track. Null when ffprobe could not report one for the
    /// source audio file.
    ///
    /// A null also shifts the ``startOffset`` of every later track and shortens the media's total
    /// duration. Refuse playback when a null-duration track is followed by another; no correct
    /// timeline can be built. On a single or final track the offsets are intact and the real
    /// duration can be read from the decoded asset.
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
