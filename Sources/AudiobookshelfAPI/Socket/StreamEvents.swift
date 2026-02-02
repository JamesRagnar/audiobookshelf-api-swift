//
//  StreamEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// A stream has opened.
public struct StreamOpenEvent: SocketInboundEvent {
    
    public static let name = "stream_open"
    
    public typealias Payload = AudiobookshelfAPI.Stream

}

/// A stream has closed.
public struct StreamClosedEvent: SocketInboundEvent {
    
    public static let name = "stream_closed"
    
    public typealias Payload = String // Stream ID

}

/// A stream transcode progress update.
public struct StreamProgressEvent: SocketInboundEvent {
    
    public static let name = "stream_progress"
    
    public typealias Payload = StreamProgress

}

/// A stream is ready, transcoding has already been completed on the requested stream.
public struct StreamReadyEvent: SocketInboundEvent {
    
    public static let name = "stream_ready"
    
    public typealias Payload = EmptyBody

}

/// A stream was reset.
public struct StreamResetEvent: SocketInboundEvent {
    
    public static let name = "stream_reset"
    
    public typealias Payload = Body

}

extension StreamResetEvent {
    
    public struct Body: Decodable, Sendable {
        
        /// The new start time (in seconds) of the stream.
        public let startTime: Float
        
        /// The ID of the stream being reset.
        public let streamId: String

    }
}

/// A stream error occurred. Emitted when ffmpeg has an error while transcoding.
public struct StreamErrorEvent: SocketInboundEvent {
    
    public static let name = "stream_error"
    
    public typealias Payload = Body

}

extension StreamErrorEvent {
    
    public struct Body: Decodable, Sendable {
        
        /// The ID of the stream where the error occurred.
        public let id: String
        
        /// The error's message.
        public let error: String

    }

}
