//
//  GetEmailSettings.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get email notification settings.
public struct GetEmailSettings: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/emails/settings"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public typealias Response = EmailSettingsResponse

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        /// Returned instead of 403 when the user is not an admin.
        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}

public extension GetEmailSettings {

    struct EmailSettingsResponse: Decodable, Sendable {

        public let settings: EmailSettings

    }

}
