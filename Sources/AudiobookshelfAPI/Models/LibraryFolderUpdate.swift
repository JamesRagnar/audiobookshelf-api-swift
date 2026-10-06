/// Complete replacement folder-list entry on 2.26.0...2.37.1.
/// Omitted existing IDs remove folders and associated library items. [] removes all folders.
public enum LibraryFolderUpdate: Encodable, Sendable {

    /// Retains an existing folder using required wire id; does not move or rename it.
    case existing(id: String)
    /// Creates a folder using required server-local wire path.
    case new(path: String)

    private enum CodingKeys: CodingKey {
        case id, path
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .existing(let id): try container.encode(id, forKey: .id)
        case .new(let path): try container.encode(path, forKey: .path)
        }
    }

}
