//
//  GetEbookFile.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-01-27.
//

import Foundation
import RagnarNetworking

/// Get ebook file for reading.
public struct GetEbookFile: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil


        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Get Ebook File Parameters
        ///
        /// - Parameters:
        ///   - libraryItemId: The ID of the library item.
        ///   - fileId: The ebook file ID (optional, uses first ebook if not specified).
        public init(libraryItemId: String, fileId: String? = nil) {
            if let fileId = fileId {
                self.path = "/api/items/\(libraryItemId)/ebook/\(fileId)"
            } else {
                self.path = "/api/items/\(libraryItemId)/ebook"
            }
        }
    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {
        case badRequest
        case notFound
    }

    public static let responseCases: ResponseCases = [
        200: .success(Response.self),
        400: .failure(AudiobookshelfError.badRequest),
        404: .failure(AudiobookshelfError.notFound)
    ]
}
