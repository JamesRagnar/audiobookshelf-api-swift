//
//  StreamEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import AudiobookshelfModel
import Foundation

/// A stream has opened.
public struct StreamOpenEvent: SocketEvent {
    
    public static let name = "stream_open"
    
    public typealias Schema = AudiobookshelfModel.Stream

}

/// A stream has closed.
public struct StreamClosedEvent: SocketEvent {
    
    public static let name = "stream_closed"
    
    public typealias Schema = String // Stream ID

}

/// A stream transcode progress update.
public struct StreamProgressEvent: SocketEvent {
    
    public static let name = "stream_progress"
    
    public typealias Schema = StreamProgress

}

/// A stream is ready, transcoding has already been completed on the requested stream.
public struct StreamReadyEvent: SocketEvent {
    
    public static let name = "stream_ready"
    
    public typealias Schema = EmptyBody

}

/// A stream was reset.
public struct StreamResetEvent: SocketEvent {
    
    public static let name = "stream_reset"
    
    public typealias Schema = Body

}

extension StreamResetEvent {
    
    public struct Body: Decodable {
        
        /// The new start time (in seconds) of the stream.
        public let startTime: Float
        
        /// The ID of the stream being reset.
        public let streamId: String

    }
}

/// A stream error occurred. Emitted when ffmpeg has an error while transcoding.
public struct StreamErrorEvent: SocketEvent {
    
    public static let name = "stream_error"
    
    public typealias Schema = Body

}

extension StreamErrorEvent {
    
    public struct Body: Decodable {
        
        /// The ID of the stream where the error occurred.
        public let id: String
        
        /// The error's message.
        public let error: String

    }

}
