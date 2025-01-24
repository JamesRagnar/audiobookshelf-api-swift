//
//  PatchMediaProgress.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-01-23.
//

import Foundation

/// This endpoint creates/updates your media progress for a library item or podcast episode.
public struct PatchMediaProgress: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        struct Body: Encodable {
            
            let duration: Float?
            
            let progress: Float?
            
            let currentTime: Float?
            
            let isFinished: Bool?
            
            let hideFromContinueListening: Bool?
            
            let finishedAt: Int?
            
            let startedAt: Int?
            
        }
        
        public let method: RequestMethod = .patch

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data?
        
        public let authentication: AuthenticationType = .bearer
        
        /// PatchMediaProgress Parameters
        ///
        /// - Parameters:
        ///   - libraryItemID: The ID of the library item to create/update media progress for.
        ///   - episodeID: The ID of the podcast episode to create/update media progress for.
        ///   - duration: The total duration (in seconds) of the media.
        ///   - progress: The percentage completion progress of the media. Will automatically be set to 1 if the media is finished.
        ///   - currentTime: The current time (in seconds) of your progress.
        ///   - isFinished: Whether the media is finished.
        ///   - hideFromContinueListening: Whether the media will be hidden from the "Continue Listening" shelf.
        ///   - finishedAt: The time (in ms since POSIX epoch) when the user finished the media. The default will be Date.now() if isFinished is true.
        ///   - startedAt: The time (in ms since POSIX epoch) when the user started consuming the media. The default will be the value of finishedAt if isFinished is true.
        public init(
            libraryItemID: String,
            episodeID: String?,
            duration: Float?,
            progress: Float?,
            currentTime: Float?,
            isFinished: Bool?,
            hideFromContinueListening: Bool?,
            finishedAt: Int?,
            startedAt: Int?
        ) throws {
            var path = "/api/me/progress/\(libraryItemID)"
            if let episodeID {
                path += "/\(episodeID)"
            }
            self.path = path
            
            self.body = try JSONEncoder().encode(
                Body(
                    duration: duration,
                    progress: progress,
                    currentTime: currentTime,
                    isFinished: isFinished,
                    hideFromContinueListening: hideFromContinueListening,
                    finishedAt: finishedAt,
                    startedAt: startedAt
                )
            )
        }
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {}
    
    public enum AudiobookshelfError: Error {
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        // Success
        200: .success(Response.self),
        
        // No library items or podcast episodes were found with the given IDs.
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}
