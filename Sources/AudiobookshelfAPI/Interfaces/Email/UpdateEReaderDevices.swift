//
//  UpdateEReaderDevices.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update the list of eReader devices for sending ebooks.
public struct UpdateEReaderDevices: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/emails/ereader-devices"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Update EReader Devices Request
        ///
        /// - Parameters:
        ///   - devices: Array of eReader devices with name and email.
        public init(devices: [EReaderDevice]) {
            self.body = Payload(ereaderDevices: devices)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let ereaderDevices: [EReaderDevice]

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        /// Returned instead of 403 when the user is not an admin.
        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension UpdateEReaderDevices.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let ereaderDevices: [EReaderDevice]

    }

}
