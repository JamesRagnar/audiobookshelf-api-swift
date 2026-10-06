import AudiobookshelfAPI
import Foundation
import Testing

private typealias Fixtures = MaintainedContractFixtures

@Suite
struct MaintainedWriteContractTests {

    @Test(arguments: [true, false])
    func apiKeyCreationSendsOwnerNameAndExplicitActive(isActive: Bool) throws {
        let request = CreateAPIKey.Request(name: "Reader", userId: "user-1", isActive: isActive, expiresIn: 3600)
        let json = try Fixtures.encoded(request.body)
        #expect(Set(json.keys) == ["name", "userId", "isActive", "expiresIn"])
        #expect(json["name"] as? String == "Reader")
        #expect(json["userId"] as? String == "user-1")
        #expect(json["isActive"] as? Bool == isActive)
        #expect(json["expiresIn"] as? Int == 3600)
        let permanent = try Fixtures.encoded(CreateAPIKey.Request(name: "Reader", userId: "user-1").body)
        #expect(permanent["expiresIn"] == nil)
        #expect(permanent["isActive"] as? Bool == true)
    }

    @Test
    func apiKeyUpdateOmitsUnspecifiedFields() throws {
        let request = UpdateAPIKey.Request(keyId: "key-1", isActive: false)
        let json = try Fixtures.encoded(request.body)
        #expect(Set(json.keys) == ["isActive"])
        #expect(json["isActive"] as? Bool == false)
    }

    @Test
    func creationEncodesFolderObjectsAndFractionalSettings() throws {
        let request = CreateLibrary.Request(
            name: "Books", folders: ["/books"], mediaType: "book",
            settings: .init(disableWatcher: false, metadataPrecedence: [],
                            markAsFinishedPercentComplete: .value(95.5),
                            markAsFinishedTimeRemaining: .value(12.25))
        )
        let json = try Fixtures.encoded(request.body)
        let folders = try #require(json["folders"] as? [[String: String]])
        let settings = try #require(json["settings"] as? [String: Any])
        #expect(folders == [["path": "/books"]])
        #expect(settings["disableWatcher"] as? Bool == false)
        #expect(settings["metadataPrecedence"] as? [String] == [])
        #expect(settings["markAsFinishedPercentComplete"] as? Double == 95.5)
        #expect(settings["markAsFinishedTimeRemaining"] as? Double == 12.25)
        #expect(json["displayOrder"] == nil)
        let created = try Fixtures.response(CreateLibrary.self, Fixtures.library)
        let updated = try Fixtures.response(UpdateLibrary.self, Fixtures.library)
        #expect(created.settings.markAsFinishedPercentComplete == 95.5)
        #expect(updated.settings.markAsFinishedTimeRemaining == 12.25)
    }

    @Test
    func updateFolderOmissionDiffersFromReplacementAndRemoval() throws {
        let omitted = try Fixtures.encoded(UpdateLibrary.Request(libraryId: "library-1").body)
        let replacement = try Fixtures.encoded(UpdateLibrary.Request(
            libraryId: "library-1", folders: [.existing(id: "folder-1"), .new(path: "/new")],
            mediaType: "book", displayOrder: 0, settings: .init(autoScanCronExpression: .null)
        ).body)
        let empty = try Fixtures.encoded(UpdateLibrary.Request(libraryId: "library-1", folders: []).body)
        #expect(omitted["folders"] == nil)
        #expect(replacement["folders"] as? [[String: String]] == [["id": "folder-1"], ["path": "/new"]])
        #expect((empty["folders"] as? [Any])?.isEmpty == true)
        #expect(replacement["displayOrder"] as? Int == 0)
        let settings = try #require(replacement["settings"] as? [String: Any])
        #expect(settings["autoScanCronExpression"] is NSNull)
    }

    @Test
    func settingsDistinguishOmissionNullAndValue() throws {
        let empty = try Fixtures.encoded(LibrarySettingsUpdate())
        let null = try Fixtures.encoded(LibrarySettingsUpdate(
            autoScanCronExpression: .null, podcastSearchRegion: .null,
            markAsFinishedPercentComplete: .null, markAsFinishedTimeRemaining: .null
        ))
        let values = try Fixtures.encoded(LibrarySettingsUpdate(
            coverAspectRatio: 0, autoScanCronExpression: .value(""), podcastSearchRegion: .value("US"),
            markAsFinishedPercentComplete: .value(0), markAsFinishedTimeRemaining: .value(0)
        ))
        #expect(empty.isEmpty)
        #expect(null.count == 4)
        #expect(null.values.allSatisfy { $0 is NSNull })
        #expect((values["autoScanCronExpression"] as? String)?.isEmpty == true)
        #expect(values["podcastSearchRegion"] as? String == "US")
        #expect(values["markAsFinishedPercentComplete"] as? Double == 0)
    }

    @Test
    func orderedFileDataEncodesInodesAndExplicitExclusion() throws {
        let request = UpdateLibraryItemTracks.Request(
            itemId: "item-1",
            orderedFileData: [.init(ino: "101"), .init(ino: "102", exclude: false), .init(ino: "103", exclude: true)]
        )
        let json = try Fixtures.encoded(request.body)
        let rows = try #require(json["orderedFileData"] as? [[String: Any]])
        #expect(json["tracks"] == nil)
        #expect(rows.map { $0["ino"] as? String } == ["101", "102", "103"])
        #expect(rows[0]["exclude"] == nil)
        #expect(rows[1]["exclude"] as? Bool == false)
        #expect(rows[2]["exclude"] as? Bool == true)
        let result = try Fixtures.response(UpdateLibraryItemTracks.self, TestFixtures.bookLibraryItemJSON)
        #expect(result.id == "li-1")
    }

    @Test
    func localCoverAndURLDownloadAreDistinctRequests() throws {
        let local = UpdateLibraryItemCover.Request(itemId: "item-1", coverPath: "/books/cover.jpg")
        let remote = DownloadLibraryItemCoverFromURL.Request(itemId: "item-1", url: "https://example.invalid/c.jpg")
        #expect(local.method == .patch)
        #expect(remote.method == .post)
        #expect(try Fixtures.encoded(local.body) as? [String: String] == ["cover": "/books/cover.jpg"])
        #expect(try Fixtures.encoded(remote.body) as? [String: String] == ["url": "https://example.invalid/c.jpg"])
        let result = try Fixtures.response(
            DownloadLibraryItemCoverFromURL.self, "{\"success\":true,\"cover\":\"/books/cover.jpg\"}"
        )
        #expect(result.success)
        #expect(result.cover == "/books/cover.jpg")
    }

    @Test(arguments: [nil, 0, 1_767_225_600_000] as [Int?])
    func shareCreationAlwaysEncodesIntegerExpiry(expiry: Int?) throws {
        let json = try Fixtures.encoded(CreateMediaItemShare.Request(
            slug: "book", mediaItemType: "book", mediaItemId: "book-1", expiresAt: expiry
        ).body)
        #expect(json["expiresAt"] as? Int == expiry ?? 0)
    }

    @Test(arguments: [nil, "https://example.invalid/apprise"] as [String?])
    func notificationsRequireExplicitReplacementValues(url: String?) throws {
        let replacement = UpdateNotificationSettings.Replacement(
            appriseApiUrl: url, maxFailedAttempts: 0, maxNotificationQueue: 12
        )
        let json = try Fixtures.encoded(UpdateNotificationSettings.Request(replacement: replacement).body)
        #expect(Set(json.keys) == ["appriseApiUrl", "maxFailedAttempts", "maxNotificationQueue"])
        #expect(json["maxFailedAttempts"] as? Int == 0)
        #expect(json["maxNotificationQueue"] as? Int == 12)
        if let url {
            #expect(json["appriseApiUrl"] as? String == url)
        } else {
            #expect(json["appriseApiUrl"] is NSNull)
        }
        let standalone = try Fixtures.encoded(replacement)
        #expect(Set(standalone.keys) == Set(json.keys))
    }

    @Test
    func userPermissionPatchesOverlayLegacyAndTransmitFalse() throws {
        let legacy = try Fixtures.decode(UserPermissions.self, """
        {"download":true,"update":true,"delete":true,"upload":true,"accessAllLibraries":true,
         "accessAllTags":true,"accessExplicitContent":true,"createEreader":true}
        """)
        let json = try Fixtures.encoded(UpdateUser.Request(
            userId: "user-1", permissions: legacy,
            permissionUpdates: .init(download: false, createEreader: false, selectedTagsNotAccessible: true)
        ).body)
        let permissions = try #require(json["permissions"] as? [String: Bool])
        #expect(permissions["download"] == false)
        #expect(permissions["update"] == true)
        #expect(permissions["createEreader"] == false)
        #expect(permissions["selectedTagsNotAccessible"] == true)
        let patch = try Fixtures.encoded(UserPermissionsPatch(download: false))
        #expect(Set(patch.keys) == ["download"])
    }

    @Test
    func arrayOnlyUserUpdatesEncodeAnEmptyPermissionsObject() throws {
        let json = try Fixtures.encoded(UpdateUser.Request(
            userId: "user-1", librariesAccessible: [], itemTagsSelected: []
        ).body)
        #expect((json["permissions"] as? [String: Bool])?.isEmpty == true)
        #expect(json["librariesAccessible"] as? [String] == [])
        #expect(json["itemTagsSelected"] as? [String] == [])
        #expect(json["email"] == nil)
        let emptyEmail = try Fixtures.encoded(UpdateUser.Request(userId: "user-1", email: "").body)
        #expect((emptyEmail["email"] as? String)?.isEmpty == true)
        let create = try Fixtures.encoded(CreateUser.Request(
            username: "reader", password: "secret", type: .user, email: "r@example.invalid",
            itemTagsSelected: [], permissionUpdates: .init(download: false)
        ).body)
        #expect(create["email"] as? String == "r@example.invalid")
        #expect(create["itemTagsSelected"] as? [String] == [])
    }

}
