//
//  StreamEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

// MARK: - Stream Events

// Emitted while the server transcodes a library item for HLS playback. A stream only exists when a
// playback session could not be direct played, so none of these fire for direct play sessions.
//
// Every event here except `stream_reset` is emitted to the user that owns the stream, so a client
// only receives events for its own playback. `stream_reset` is broadcast to every client and must be
// matched on `streamId`.

/// The stream has produced enough segments for playback to begin.
///
/// Emitted once per stream, either when the first several segments have been written or, for very
/// short items, when transcoding finishes before that threshold is reached.
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
/// Emitted once when the transcode loop starts, with zeroed values, and then every two seconds until
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
/// - Note: Unlike the other stream events, this is broadcast to every connected client rather than
///   only the stream's owner. Match ``Body/streamId`` against the active stream before acting on it.
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
/// Closing the stream does not close the playback session, so no session event follows this. The
/// client is expected to tear down playback itself.
///
/// - Note: One failure path is silent: an intentional `SIGKILL` of the ffmpeg process is handled
///   without emitting this event or ``StreamClosedEvent``. A client that only listens here will not
///   learn about that case, and will instead see subsequent segment requests start returning 404.
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
