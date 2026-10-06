import Foundation

/// Stored API-key record on 2.26.0...2.37.1. The secret is returned only by CreateAPIKey.
/// Optional values accept missing/null; required values reject both.
public struct APIKey: Decodable, Sendable {

    /// Stored permissions JSON; this is not a separate authorization-scope guarantee.
    public struct Permissions: Codable, Sendable {
        public let download: Bool
        public let update: Bool
        public let delete: Bool
        public let upload: Bool
        public let accessAllLibraries: Bool
        public let accessAllTags: Bool
        public let accessExplicitContent: Bool
        public let selectedTagsNotAccessible: Bool?
        public let librariesAccessible: [String]?
        public let itemTagsSelected: [String]?
        /// Optional e-reader creation permission; exact wire spelling is createEreader.
        public let createEreader: Bool?
    }

    /// Related user summary; additional owner fields on no-op updates are ignored.
    public struct UserSummary: Decodable, Sendable {
        /// Required related user ID, wire key id.
        public let id: String
        /// Required login name, wire key username.
        public let username: String
        /// Required account type: root, guest, user or admin, wire key type.
        public let type: User.UserType
    }

    /// Required key identifier, wire key id.
    public let id: String
    /// Required display name, wire key name.
    public let name: String
    /// Nullable stored description, wire key description.
    public let description: String?
    /// Required owning user ID, wire key userId.
    public let userId: String
    /// Required authentication-enabled flag, wire key isActive.
    public let isActive: Bool
    /// Nullable stored permissions object, wire key permissions.
    public let permissions: Permissions?
    /// Nullable ISO-8601 expiry, wire key expiresAt; nil means non-expiring.
    public let expiresAt: Date?
    /// Nullable ISO-8601 last-use date, wire key lastUsedAt.
    public let lastUsedAt: Date?
    /// Nullable creator ID after deletion, wire key createdByUserId.
    public let createdByUserId: String?
    /// Required ISO-8601 creation date, wire key createdAt.
    public let createdAt: Date
    /// Required ISO-8601 update date, wire key updatedAt.
    public let updatedAt: Date
    /// Optional related owner on create/list/update, wire key user.
    public let user: UserSummary?
    /// Optional creator summary on list, wire key createdByUser.
    public let createdByUser: UserSummary?

    private enum CodingKeys: CodingKey {
        case id, name, description, userId, isActive, permissions, expiresAt, lastUsedAt
        case createdByUserId, createdAt, updatedAt, user, createdByUser
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        userId = try container.decode(String.self, forKey: .userId)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        permissions = try container.decodeIfPresent(Permissions.self, forKey: .permissions)
        expiresAt = try container.decodeISODateIfPresent(forKey: .expiresAt)
        lastUsedAt = try container.decodeISODateIfPresent(forKey: .lastUsedAt)
        createdByUserId = try container.decodeIfPresent(String.self, forKey: .createdByUserId)
        createdAt = try container.decodeISODate(forKey: .createdAt)
        updatedAt = try container.decodeISODate(forKey: .updatedAt)
        user = try container.decodeIfPresent(UserSummary.self, forKey: .user)
        createdByUser = try container.decodeIfPresent(UserSummary.self, forKey: .createdByUser)
    }

}
