//
//  StreamEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarSocketIO

// MARK: - Stream Events

// A stream exists only for transcoded playback sessions. None of these fire for direct play.
//
// All are emitted to the user that owns the stream, except `stream_reset`, which is broadcast.

/// The stream has produced enough segments for playback to begin.
///
/// Emitted once per stream, after the first several segments are written or, for short items, when
/// transcoding finishes first.
public struct StreamOpenEvent: SocketEvent {

    public static let name = "stream_open"

    public typealias Schema = AudiobookshelfAPI.Stream

}

/// The stream was closed without an error.
///
/// The payload is the stream ID on its own, not an object.
public struct StreamClosedEvent: SocketEvent {

    public static let name = "stream_closed"

    public typealias Schema = String

}

/// A transcode progress update.
///
/// Emitted with zeroed values when the transcode loop starts, then every two seconds until
/// transcoding completes.
public struct StreamProgressEvent: SocketEvent {

    public static let name = "stream_progress"

    public typealias Schema = StreamProgress

}

/// Transcoding finished and the whole stream is available.
public struct StreamReadyEvent: SocketEvent {

    public static let name = "stream_ready"

    public typealias Schema = SocketEmptyBody

}

/// An HLS stream was reset because the requested segment fell outside the transcoded range.
///
/// - Note: Broadcast to every client rather than only the stream's owner. Match ``Body/streamId``
///   against the active stream before acting on it.
public struct StreamResetEvent: SocketEvent {

    public static let name = "stream_reset"

    public typealias Schema = Body

}

extension StreamResetEvent {

    public struct Body: Decodable, Sendable {

        /// The new start time (in seconds) of the stream.
        public let startTime: Float

        /// The ID of the stream being reset.
        public let streamId: String

    }

}

/// The stream was closed because transcoding failed.
///
/// Closing the stream does not close the playback session, so no session event follows.
///
/// - Note: An intentional `SIGKILL` of the ffmpeg process emits neither this nor
///   ``StreamClosedEvent``. That case surfaces as subsequent segment requests returning 404.
public struct StreamErrorEvent: SocketEvent {

    public static let name = "stream_error"

    public typealias Schema = Body

}

extension StreamErrorEvent {

    public struct Body: Decodable, Sendable {

        /// The ID of the stream where the error occurred.
        public let id: String

        /// The error's message.
        public let error: String

    }

}
