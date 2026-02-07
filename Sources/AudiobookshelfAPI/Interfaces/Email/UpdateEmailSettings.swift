//
//  UpdateEmailSettings.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update email notification settings.
public struct UpdateEmailSettings: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String = "/api/emails/settings"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Update Email Settings Parameters
        ///
        /// - Parameters:
        ///   - host: SMTP server host.
        ///   - port: SMTP server port.
        ///   - secure: Whether to use secure connection.
        ///   - user: SMTP username.
        ///   - pass: SMTP password.
        ///   - fromAddress: Email address to send from.
        ///   - testAddress: Email address for test messages.
        public init(
            host: String? = nil,
            port: Int? = nil,
            secure: Bool? = nil,
            user: String? = nil,
            pass: String? = nil,
            fromAddress: String? = nil,
            testAddress: String? = nil
        ) {
            self.body = Payload(
                host: host,
                port: port,
                secure: secure,
                user: user,
                pass: pass,
                fromAddress: fromAddress,
                testAddress: testAddress
            )
        }

    }

    // MARK: Response

    public typealias Response = EmailSettingsResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]

}

public extension UpdateEmailSettings.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let host: String?

        let port: Int?

        let secure: Bool?

        let user: String?

        let pass: String?

        let fromAddress: String?

        let testAddress: String?

    }

}

public extension UpdateEmailSettings {

    struct EmailSettingsResponse: Decodable, Sendable {

        public let settings: EmailSettings

    }

}
