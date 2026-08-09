//
//  UpdateUserEReaderDevices.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update the authenticated user's e-reader devices for sending ebooks.
/// User-scoped updates require `availabilityOption` to be `specificUsers` and
/// `users` to contain exactly the authenticated user's ID.
public struct UpdateUserEReaderDevices: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/me/ereader-devices"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Update User E-Reader Devices Request
        ///
        /// - Parameter devices: Array of e-reader device configurations
        public init(devices: [EReaderDevice]) {
            self.body = Payload(ereaderDevices: devices)
        }
    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The eReader devices now accessible to the authenticated user.
        public let ereaderDevices: [EReaderDevice]

    }

    public enum AudiobookshelfError: Error, Sendable {
        case badRequest
    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest))
        ]
    )
}

public extension UpdateUserEReaderDevices.Request {

    struct Payload: RequestBody, Encodable, Sendable {
        let ereaderDevices: [EReaderDevice]
    }

}
