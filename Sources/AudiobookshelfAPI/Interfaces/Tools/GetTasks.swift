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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/tasks"

        public let queryItems: [String : String]?

        public let headers: [String : String]? = nil

        public let body: Data? = nil

        public let authentication: AuthenticationType = .bearer

        /// Get Tasks Parameters
        ///
        /// - Parameters:
        ///   - includeQueue: Whether to include queued task data.
        public init(includeQueue: Bool = false) {
            var queryItems: [String: String] = [:]
            if includeQueue {
                queryItems["include"] = "queue"
            }
            self.queryItems = queryItems.isEmpty ? nil : queryItems
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let tasks: [Task]

        public let queuedTaskData: QueuedTaskData?

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self)

    ]

}

public extension GetTasks {

    struct Task: Decodable, Sendable {

        // Task structure from TaskManager (flexible for various task types)

    }

    struct QueuedTaskData: Decodable, Sendable {

        // Queued task data structure

    }

}
