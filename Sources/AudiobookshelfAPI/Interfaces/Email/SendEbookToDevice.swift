//
//  SendEbookToDevice.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Send an ebook to an eReader device via email.
public struct SendEbookToDevice: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/emails/send-ebook-to-device"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Send Ebook To Device Parameters
        ///
        /// - Parameters:
        ///   - libraryItemId: The ID of the library item containing the ebook.
        ///   - deviceName: The name of the eReader device to send to.
        public init(
            libraryItemId: String,
            deviceName: String
        ) {
            self.body = Payload(libraryItemId: libraryItemId, deviceName: deviceName)
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .noContent),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound)),
    ]

}

public extension SendEbookToDevice.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let libraryItemId: String

        let deviceName: String

    }

}
