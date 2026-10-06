/// Partial Boolean permissions write on 2.26.0+; nil omits a key, explicit false is sent.
/// Library/tag selection arrays remain at the request's top level.
public struct UserPermissionsPatch: Encodable, Sendable {

    /// Optional wire download; nil preserves on update.
    public let download: Bool?

    /// Optional wire update; nil preserves on update.
    public let update: Bool?

    /// Optional wire delete; nil preserves on update.
    public let delete: Bool?

    /// Optional wire upload; nil preserves on update.
    public let upload: Bool?

    /// Optional wire createEreader; nil preserves on update.
    public let createEreader: Bool?

    /// Optional wire accessAllLibraries; nil preserves on update.
    public let accessAllLibraries: Bool?

    /// Optional wire accessAllTags; nil preserves on update.
    public let accessAllTags: Bool?

    /// Optional wire accessExplicitContent; nil preserves on update.
    public let accessExplicitContent: Bool?

    /// Optional wire selectedTagsNotAccessible; nil preserves on update.
    public let selectedTagsNotAccessible: Bool?

    /// Creates a Boolean patch; matching wire keys are omitted for nil arguments.
    /// - Parameters:
    ///   - download: Permission to download media from the server.
    ///   - update: Permission to update library items.
    ///   - delete: Permission to delete library items.
    ///   - upload: Permission to upload items to the server.
    ///   - createEreader: Permission to create e-reader devices; exact wire casing.
    ///   - accessAllLibraries: Bypasses library selections.
    ///   - accessAllTags: Bypasses tag selections.
    ///   - accessExplicitContent: Permission to access explicit content.
    ///   - selectedTagsNotAccessible: Uses itemTagsSelected as a denylist when accessAllTags is false.
    public init(
        download: Bool? = nil,
        update: Bool? = nil,
        delete: Bool? = nil,
        upload: Bool? = nil,
        createEreader: Bool? = nil,
        accessAllLibraries: Bool? = nil,
        accessAllTags: Bool? = nil,
        accessExplicitContent: Bool? = nil,
        selectedTagsNotAccessible: Bool? = nil
    ) {
        self.download = download
        self.update = update
        self.delete = delete
        self.upload = upload
        self.createEreader = createEreader
        self.accessAllLibraries = accessAllLibraries
        self.accessAllTags = accessAllTags
        self.accessExplicitContent = accessExplicitContent
        self.selectedTagsNotAccessible = selectedTagsNotAccessible
    }

    func merging(_ legacy: UserPermissions?) -> [String: Bool] {
        var values: [String: Bool] = [:]
        if let legacy {
            values["download"] = legacy.download
            values["update"] = legacy.update
            values["delete"] = legacy.delete
            values["upload"] = legacy.upload
            values["createEreader"] = legacy.createEreader
            values["accessAllLibraries"] = legacy.accessAllLibraries
            values["accessAllTags"] = legacy.accessAllTags
            values["accessExplicitContent"] = legacy.accessExplicitContent
            values["selectedTagsNotAccessible"] = legacy.selectedTagsNotAccessible
        }
        if let download { values["download"] = download }
        if let update { values["update"] = update }
        if let delete { values["delete"] = delete }
        if let upload { values["upload"] = upload }
        if let createEreader { values["createEreader"] = createEreader }
        if let accessAllLibraries { values["accessAllLibraries"] = accessAllLibraries }
        if let accessAllTags { values["accessAllTags"] = accessAllTags }
        if let accessExplicitContent { values["accessExplicitContent"] = accessExplicitContent }
        if let selectedTagsNotAccessible { values["selectedTagsNotAccessible"] = selectedTagsNotAccessible }
        return values
    }

}
