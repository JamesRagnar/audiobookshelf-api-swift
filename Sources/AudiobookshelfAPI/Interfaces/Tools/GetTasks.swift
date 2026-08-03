//
//  GetTasks.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get all running tasks.
public struct GetTasks: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/tasks"

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Tasks Request
        ///
        /// - Parameters:
        ///   - includeQueue: Whether to include queued task data.
        public init(includeQueue: Bool = false) {
            var queryItems: [URLQueryItem] = []
            if includeQueue {
                queryItems.append(URLQueryItem(name: "include", value: "queue"))
            }
            self.queryItems = queryItems.isEmpty ? nil : queryItems
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let tasks: [BackgroundTask]

        public let queuedTaskData: QueuedTaskData?

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200)
    )

}

public extension GetTasks {

    struct QueuedTaskData: Decodable, Sendable {

        /// Queued metadata embedding tasks.
        public let embedMetadata: [EmbedMetadataTask]

    }

    struct EmbedMetadataTask: Decodable, Sendable {

        /// The ID of the library item.
        public let libraryItemId: String

        /// The directory path of the library item.
        public let libraryItemDir: String?

        /// The ID of the user who queued the task.
        public let userId: String?

        /// The cover path for the library item.
        public let coverPath: String?

        /// The total duration of the audio content.
        public let duration: Double?

    }

}
