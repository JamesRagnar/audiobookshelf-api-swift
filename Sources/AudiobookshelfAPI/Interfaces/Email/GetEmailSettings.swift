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

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public typealias Response = EmailSettings

    public enum AudiobookshelfError: Error {

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden)

    ]

}

public extension GetEmailSettings {

    struct EmailSettings: Decodable, Sendable {

        public let host: String?

        public let port: Int?

        public let secure: Bool?

        public let user: String?

        public let pass: String?

        public let fromAddress: String?

        public let testAddress: String?

    }

}
