//
//  GetLibrary.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves a library.
public struct GetLibrary: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public enum Include: String {
            case filterData = "filterdata"
        }

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Library Request
        ///
        /// - Parameters:
        ///   - libraryID: The ID of the library to retrieve.
        ///   - include: A comma separated list of what to include with the library item.
        public init(
            libraryID: String,
            include: Set<Include>?
        ) {
            self.path = "/api/libraries/\(libraryID)"

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("include", include?.joined())
            self.queryItems = queryItems
        }

    }

    // MARK: Response

    public struct Response: Sendable {

        /// The library object. Always present in both response modes.
        public let library: Library

        /// Filter data for the library. Only present when requested with `?include=filterdata`.
        public let filterdata: FilterData?

        /// Number of issues in the library. Only present when requested with `?include=filterdata`.
        public let issues: Int?

        /// Number of user playlists in this library. Only present when requested with `?include=filterdata`.
        public let numUserPlaylists: Int?

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// The `limit` or `page` query parameter was not a non-negative integer.
        case badRequest

        /// You do not have access to this library.
        case forbidden

        ///
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

extension GetLibrary.Response: Decodable {

    enum CodingKeys: String, CodingKey {
        case library
        case filterdata
        case issues
        case numUserPlaylists
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Check if this is the expanded response with filterdata
        if container.contains(.filterdata) {
            // Mode B: Wrapper response with filterdata
            self.filterdata = try container.decode(FilterData.self, forKey: .filterdata)
            self.issues = try container.decode(Int.self, forKey: .issues)
            self.numUserPlaylists = try container.decode(Int.self, forKey: .numUserPlaylists)
            self.library = try container.decode(Library.self, forKey: .library)
        } else {
            // Mode A: Direct library response
            self.filterdata = nil
            self.issues = nil
            self.numUserPlaylists = nil
            self.library = try Library(from: decoder)
        }
    }

}

extension GetLibrary.Response: InterfaceResponse {}
