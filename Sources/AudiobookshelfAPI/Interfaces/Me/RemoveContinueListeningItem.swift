//
//  RemoveContinueListeningItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint removes a library item, that has media progress associated with your user, from your "Continue
/// Listening" shelf. Your user is returned.
public struct RemoveContinueListeningItem: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Remove Continue Listening Item
        ///
        /// - Parameter mediaProgressID: The ID of the media progress that refers to the library item to remove.
        public init(mediaProgressID: String) {
            self.path = "/api/me/progress/\(mediaProgressID)/remove-from-continue-listening"
        }

    }

    // MARK: Response

    public typealias Response = User

    public static let responseCases: ResponseMap = [

        .code(200, .decode)
    ]

}
