//
//  BatchCreateUpdateMediaProgress.swift.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint batch creates/updates your media progress.
public struct BatchCreateUpdateMediaProgress: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public struct ProgressItem: Encodable, Sendable {

            /// The ID of the library item the media progress is for.
            public let libraryItemId: String

            /// The ID of the podcast episode the media progress is for.
            public let episodeId: String?

            /// The total duration (in seconds) of the media.
            public let duration: Float?

            /// The percentage completion progress of the media. Will automatically be set to 1 if the media is
            /// finished.
            public let progress: Float?

            /// The current time (in seconds) of your progress.
            public let currentTime: Float?

            /// Whether the media is finished.
            public let isFinished: Bool?

            /// Whether the media will be hidden from the "Continue Listening" shelf.
            public let hideFromContinueListening: Bool?

            /// The ebook location for ebook progress.
            public let ebookLocation: String?

            /// The ebook progress percentage.
            public let ebookProgress: Float?

            /// The time (in ms since POSIX epoch) when the user finished the media. The default will be Date.now() if
            /// isFinished is true.
            public let finishedAt: Int?

            /// The time (in ms since POSIX epoch) when the progress was created.
            public let createdAt: Int?

            /// The time (in ms since POSIX epoch) when the progress was last updated.
            public let lastUpdate: Int?

            /// The remaining time used when marking the media as finished.
            public let markAsFinishedTimeRemaining: Float?

            /// The completion percentage used when marking the media as finished.
            public let markAsFinishedPercentComplete: Float?

            public init(
                libraryItemId: String,
                episodeId: String? = nil,
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
                self.libraryItemId = libraryItemId
                self.episodeId = episodeId
                self.duration = duration
                self.progress = progress
                self.currentTime = currentTime
                self.isFinished = isFinished
                self.hideFromContinueListening = hideFromContinueListening
                self.ebookLocation = ebookLocation
                self.ebookProgress = ebookProgress
                self.finishedAt = finishedAt
                self.createdAt = createdAt
                self.lastUpdate = lastUpdate
                self.markAsFinishedTimeRemaining = markAsFinishedTimeRemaining
                self.markAsFinishedPercentComplete = markAsFinishedPercentComplete
            }

        }

        public let method: RequestMethod = .patch

        public let path: String = "/api/me/progress/batch/update"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = ArrayBody<ProgressItem>

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Batch Create/Update Media Progress Request
        ///
        /// - Parameter progressItems: The Progress items to update
        public init(progressItems: [ProgressItem]) {
            self.body = ArrayBody(progressItems)
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            /// The provided array must have a non-zero length.
            .code(400, .error(AudiobookshelfError.badRequest))
        ]
    )

}
