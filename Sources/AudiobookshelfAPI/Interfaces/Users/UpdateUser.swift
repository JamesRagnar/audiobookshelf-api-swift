//
//  UpdateUser.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update a user.
public struct UpdateUser: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// User write on 2.26.0+.
        /// - Parameters:
        ///   - email: Optional wire email; nil omits. Only a nonempty string applies; empty/null cannot clear it.
        ///   - itemTagsSelected: Optional top-level wire tag list; nil preserves;
        ///     [] explicitly clears selection. accessAllTags bypasses this list.
        ///   - permissions: Optional legacy Boolean permissions object.
        ///   - permissionUpdates: Optional Boolean patch; non-nil patch members override legacy values.
        public init(
            userId: String,
            username: String? = nil,
            password: String? = nil,
            type: User.UserType? = nil,
            isActive: Bool? = nil,
            librariesAccessible: [String]? = nil,
            permissions: UserPermissions? = nil,
            email: String? = nil,
            itemTagsSelected: [String]? = nil,
            permissionUpdates: UserPermissionsPatch? = nil
        ) {
            self.path = "/api/users/\(userId)"
            self.body = Payload(
                username: username,
                password: password,
                type: type,
                isActive: isActive,
                isLocked: nil,
                librariesAccessible: librariesAccessible,
                permissions: permissions != nil || permissionUpdates != nil
                    || librariesAccessible != nil || itemTagsSelected != nil
                    ? (permissionUpdates ?? UserPermissionsPatch()).merging(permissions) : nil,
                email: email,
                itemTagsSelected: itemTagsSelected
            )
        }

        /// User write on 2.26.0+.
        /// - Parameters:
        ///   - email: Optional wire email; nil omits. Only a nonempty string applies; empty/null cannot clear it.
        ///   - itemTagsSelected: Optional top-level wire tag list; nil preserves;
        ///     [] explicitly clears selection. accessAllTags bypasses this list.
        ///   - permissions: Optional legacy Boolean permissions object.
        ///   - permissionUpdates: Optional Boolean patch; non-nil patch members override legacy values.
        ///   - isLocked: Legacy wire Boolean, encoded when non-nil; ignored on 2.26.0...2.37.1.
        @available(*, deprecated, message: "isLocked is ignored; use the initializer without isLocked.")
        public init(
            userId: String,
            username: String? = nil,
            password: String? = nil,
            type: User.UserType? = nil,
            isActive: Bool? = nil,
            isLocked: Bool?,
            librariesAccessible: [String]? = nil,
            permissions: UserPermissions? = nil,
            email: String? = nil,
            itemTagsSelected: [String]? = nil,
            permissionUpdates: UserPermissionsPatch? = nil
        ) {
            self.path = "/api/users/\(userId)"
            self.body = Payload(
                username: username,
                password: password,
                type: type,
                isActive: isActive,
                isLocked: isLocked,
                librariesAccessible: librariesAccessible,
                permissions: permissions != nil || permissionUpdates != nil
                    || librariesAccessible != nil || itemTagsSelected != nil
                    ? (permissionUpdates ?? UserPermissionsPatch()).merging(permissions) : nil,
                email: email,
                itemTagsSelected: itemTagsSelected
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// Whether the update was applied.
        public let success: Bool

        /// The updated user.
        ///
        /// - Note: This endpoint never returns rotated tokens, even when the update invalidated the
        ///   user's sessions. An admin changing their own password should use
        ///   `UpdatePasswordWithTokenRotation` instead.
        public let user: User

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

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

public extension UpdateUser.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let username: String?

        let password: String?

        let type: User.UserType?

        let isActive: Bool?

        let isLocked: Bool?

        let librariesAccessible: [String]?

        let permissions: [String: Bool]?

        let email: String?

        let itemTagsSelected: [String]?

    }

}
