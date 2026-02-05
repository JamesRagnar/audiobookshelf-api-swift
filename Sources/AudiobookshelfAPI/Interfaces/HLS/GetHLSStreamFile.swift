//
//  GetHLSStreamFile.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-27.
//

import Foundation
import RagnarNetworking

/// Get HLS stream file (playlist or segment).
public struct GetHLSStreamFile: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Get HLS Stream File Parameters
        ///
        /// - Parameters:
        ///   - streamId: The stream ID (UUID).
        ///   - file: The filename (must end with .ts or .m3u8).
        public init(streamId: String, file: String) {
            self.path = "/hls/\(streamId)/\(file)"
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
