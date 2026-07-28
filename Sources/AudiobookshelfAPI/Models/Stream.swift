//
//  Stream.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct Stream {

    /// The ID of the stream. It will be the same as the ID of the playback session that the stream is for.
    public let id: String

    /// The ID of the user that started the stream.
    public let userId: String

    /// The library item the stream is for.
    public let libraryItem: LibraryItem

    /// The podcast episode the stream is for. Will be null if the stream is for a book.
    public let episode: PodcastEpisode?

    /// The length (in seconds) of each segment of the stream.
    public let segmentLength: Int

    /// The path on the server of the stream output.
    public let playlistPath: String

    /// The URI path for the client to access the stream.
    public let clientPlaylistUri: String

    /// The time (in seconds) where the playback session started.
    public let startTime: Float

    /// The segment where the transcoding began.
    public let segmentStartNumber: Int

    /// Whether transcoding is complete.
    public let isTranscodeComplete: Bool

}

extension Stream: Decodable {}
extension Stream: Sendable {}
