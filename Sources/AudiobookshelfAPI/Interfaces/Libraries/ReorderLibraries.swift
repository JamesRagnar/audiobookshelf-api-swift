//
//  ReorderLibraries.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Reorder libraries by setting display order.
public struct ReorderLibraries: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/libraries/order"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        public init(libraries: [LibraryOrder]) throws {
            self.body = try JSONEncoder().encode(
                Body(libraries: libraries)
            )
        }

    }

    // MARK: Response

    public typealias Response = [Library]

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

    ]

}

public extension ReorderLibraries {

    struct LibraryOrder: Encodable {

        public let id: String

        public let displayOrder: Int

        public init(id: String, displayOrder: Int) {
            self.id = id
            self.displayOrder = displayOrder
        }

    }

}

public extension ReorderLibraries.Parameters {

    struct Body: Encodable {

        let libraries: [ReorderLibraries.LibraryOrder]

    }

}
