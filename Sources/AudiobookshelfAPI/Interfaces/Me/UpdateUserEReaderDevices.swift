//
//  UpdateUserEReaderDevices.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update the authenticated user's e-reader devices for sending ebooks.
public struct UpdateUserEReaderDevices: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/me/ereader-devices"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Update User E-Reader Devices Parameters
        ///
        /// - Parameter devices: Array of e-reader device configurations
        public init(devices: [EReaderDevice]) throws {
            self.body = try JSONEncoder().encode(Body(ereaderDevices: devices))
        }
    }

    // MARK: Response

    public typealias Response = User

    public enum AudiobookshelfError: Error {
        case badRequest
    }

    public static let responseCases: ResponseCases = [
        200: .success(Response.self),
        400: .failure(AudiobookshelfError.badRequest)
    ]
}

public extension UpdateUserEReaderDevices.Parameters {

    struct Body: Encodable {
        let ereaderDevices: [EReaderDevice]
    }

}
