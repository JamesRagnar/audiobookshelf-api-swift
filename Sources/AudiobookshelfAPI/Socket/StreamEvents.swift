//
//  StreamEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// An HLS stream was reset because the requested segment fell outside the transcoded range.
///
/// This is the only stream event the server still emits. The older `stream_open`, `stream_closed`,
/// `stream_progress`, `stream_ready` and `stream_error` events were removed from the server well
/// before the package's minimum supported version and can never fire.
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
