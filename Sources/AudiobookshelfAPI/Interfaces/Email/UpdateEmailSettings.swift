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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String = "/api/emails/settings"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Update Email Settings Request
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

        /// Returned instead of 403 when the user is not an admin.
        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension UpdateEmailSettings.Request {

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

    struct EmailSettingsResponse: Decodable, Sendable, InterfaceResponse {

        public let settings: EmailSettings

    }

}
