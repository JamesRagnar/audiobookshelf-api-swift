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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/emails/ereader-devices"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Update EReader Devices Parameters
        ///
        /// - Parameters:
        ///   - devices: Array of eReader devices with name and email.
        public init(devices: [EReaderDevice]) throws {
            self.body = try JSONEncoder().encode(Body(ereaderDevices: devices))
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let ereaderDevices: [EReaderDevice]

    }

    public enum AudiobookshelfError: Error {

        case badRequest

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest)

    ]

}

extension UpdateEReaderDevices.Parameters {

    struct Body: Encodable {

        let ereaderDevices: [UpdateEReaderDevices.EReaderDevice]

    }

}

public extension UpdateEReaderDevices {

    struct EReaderDevice: Codable, Sendable {

        public let name: String

        public let email: String

        public init(name: String, email: String) {
            self.name = name
            self.email = email
        }

    }

}
