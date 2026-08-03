//
//  PatchMediaProgress.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-01-23.
//

import Foundation
import RagnarNetworking

/// This endpoint creates/updates your media progress for a library item or podcast episode.
public struct PatchMediaProgress: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// PatchMediaProgress Request
        ///
        /// - Parameters:
        ///   - libraryItemID: The ID of the library item to create/update media progress for.
        ///   - episodeID: The ID of the podcast episode to create/update media progress for.
        ///   - duration: The total duration (in seconds) of the media.
        /// - progress: The percentage completion progress of the media. Will automatically be set to 1 if the media is
        /// finished.
        ///   - currentTime: The current time (in seconds) of your progress.
        ///   - isFinished: Whether the media is finished.
        ///   - hideFromContinueListening: Whether the media will be hidden from the "Continue Listening" shelf.
        ///   - ebookLocation: The ebook location for ebook progress.
        ///   - ebookProgress: The ebook progress percentage.
        /// - finishedAt: The time (in ms since POSIX epoch) when the user finished the media. The default will be
        /// Date.now() if isFinished is true.
        ///   - createdAt: The time (in ms since POSIX epoch) when the media progress was created.
        ///   - lastUpdate: The time (in ms since POSIX epoch) when the media progress was last updated.
        ///   - markAsFinishedTimeRemaining: Time remaining when marking as finished.
        ///   - markAsFinishedPercentComplete: Percent complete when marking as finished.
        public init(
            libraryItemID: String,
            episodeID: String? = nil,
            duration: Float? = nil,
            progress: Float? = nil,
            currentTime: Float? = nil,
            isFinished: Bool? = nil,
            hideFromContinueListening: Bool? = nil,
            ebookLocation: String? = nil,
            ebookProgress: Float? = nil,
            finishedAt: Int? = nil,
            createdAt: Int? = nil,
            lastUpdate: Int? = nil,
            markAsFinishedTimeRemaining: Float? = nil,
            markAsFinishedPercentComplete: Float? = nil
        ) {
            var path = "/api/me/progress/\(libraryItemID)"
            if let episodeID {
                path += "/\(episodeID)"
            }
            self.path = path

            self.body = Payload(
                duration: duration,
                currentTime: currentTime,
                progress: progress,
                isFinished: isFinished,
                hideFromContinueListening: hideFromContinueListening,
                ebookLocation: ebookLocation,
                ebookProgress: ebookProgress,
                finishedAt: finishedAt,
                createdAt: createdAt,
                lastUpdate: lastUpdate,
                markAsFinishedTimeRemaining: markAsFinishedTimeRemaining,
                markAsFinishedPercentComplete: markAsFinishedPercentComplete
            )
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            // Invalid request payload for the target media.
            .code(400, .error(AudiobookshelfError.badRequest)),
            // No library items or podcast episodes were found with the given IDs.
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension PatchMediaProgress.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let duration: Float?

        let currentTime: Float?

        let progress: Float?

        let isFinished: Bool?

        let hideFromContinueListening: Bool?

        let ebookLocation: String?

        let ebookProgress: Float?

        let finishedAt: Int?

        let createdAt: Int?

        let lastUpdate: Int?

        let markAsFinishedTimeRemaining: Float?

        let markAsFinishedPercentComplete: Float?

    }

}
