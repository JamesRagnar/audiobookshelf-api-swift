import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct MediaProgressWriteContractTests {
    @Test(arguments: [Float(0), 0.42, 1])
    func readingWritesPreserveExplicitFractionAndOmitUnrelatedFields(fraction: Float) throws {
        let request = PatchMediaProgress.Request(
            libraryItemID: "item-1", ebookLocation: "epubcfi(/6/2!/4/1:0)", ebookProgress: fraction
        )
        let object = try jsonObject(request.body)
        #expect(request.path == "/api/me/progress/item-1")
        #expect(Set(object.keys) == ["ebookLocation", "ebookProgress"])
        #expect((object["ebookProgress"] as? NSNumber)?.floatValue == fraction)
        #expect(object["ebookLocation"] as? String == "epubcfi(/6/2!/4/1:0)")
    }

    @Test
    func finishedOnlyWriteDoesNotFabricatePositions() throws {
        let request = PatchMediaProgress.Request(libraryItemID: "item-1", isFinished: true, finishedAt: 5_000)
        let object = try jsonObject(request.body)
        #expect(Set(object.keys) == ["isFinished", "finishedAt"])
        #expect(object["isFinished"] as? Bool == true)
        #expect(object["finishedAt"] as? Int == 5_000)
    }

    @Test
    func unfinishedOnlyWritePreservesFalseAndOmitsNil() throws {
        let request = PatchMediaProgress.Request(libraryItemID: "item-1", isFinished: false)
        let object = try jsonObject(request.body)
        #expect(Set(object.keys) == ["isFinished"])
        #expect(object["isFinished"] as? Bool == false)
    }

    @Test
    func completionControlsUseTheirWireUnitsAndPreserveZero() throws {
        let request = PatchMediaProgress.Request(
            libraryItemID: "item-1", markAsFinishedTimeRemaining: 0, markAsFinishedPercentComplete: 100
        )
        let object = try jsonObject(request.body)
        #expect(Set(object.keys) == ["markAsFinishedTimeRemaining", "markAsFinishedPercentComplete"])
        #expect(object["markAsFinishedTimeRemaining"] as? Double == 0)
        #expect(object["markAsFinishedPercentComplete"] as? Double == 100)
    }

    @Test
    func batchPreservesZeroAndFalseWithoutAudioDefaults() throws {
        let request = BatchCreateUpdateMediaProgress.Request.ProgressItem(
            libraryItemId: "item-1", isFinished: false, ebookLocation: "1", ebookProgress: 0
        )
        let object = try JSONSerialization.jsonObject(with: JSONEncoder().encode(request))
        let fields = try #require(object as? [String: Any])
        #expect(Set(fields.keys) == ["libraryItemId", "isFinished", "ebookLocation", "ebookProgress"])
        #expect(fields["isFinished"] as? Bool == false)
        #expect(fields["ebookProgress"] as? Double == 0)
    }

    @Test
    func creationTimestampIsCreatedAtInBothWriteContracts() throws {
        let single = try jsonObject(PatchMediaProgress.Request(libraryItemID: "item-1", createdAt: 1_000).body)
        let batch = BatchCreateUpdateMediaProgress.Request.ProgressItem(libraryItemId: "item-1", createdAt: 1_000)
        let object = try #require(JSONSerialization.jsonObject(with: JSONEncoder().encode(batch)) as? [String: Any])
        #expect(Set(single.keys) == ["createdAt"])
        #expect(single["createdAt"] as? Int == 1_000)
        #expect(Set(object.keys) == ["libraryItemId", "createdAt"])
        #expect(object["createdAt"] as? Int == 1_000)
    }

    @Test
    func sharedCompletionDoesNotCoerceEitherPositionOrIdentity() throws {
        let progress = try decode([
            "ebookLocation": "epubcfi(/6/2!/4/1:3)", "ebookProgress": 0.6,
            "progress": 1, "isFinished": true, "finishedAt": 5_000
        ])
        #expect(progress.id == "record-1")
        #expect(progress.libraryItemId == "item-1")
        #expect(progress.mediaItemId == "book-1")
        #expect(progress.duration == 1_000)
        #expect(progress.currentTime == 300)
        #expect(progress.progress == 1)
        #expect(progress.isFinished)
        #expect(progress.ebookLocation == "epubcfi(/6/2!/4/1:3)")
        #expect(progress.ebookProgress == 0.6)
        #expect(progress.startedAt == 1_000)
    }

    @Test
    func ebookEndDoesNotSynthesizeCompletion() throws {
        let progress = try decode(["ebookProgress": 1, "ebookLocation": "12"])
        #expect(progress.ebookProgress == 1)
        #expect(!progress.isFinished)
        #expect(progress.finishedAt == nil)
        #expect(progress.currentTime == 300)
    }

    @Test(arguments: [false, true])
    func absentAndNullEbookFieldsRemainOptional(explicitNull: Bool) throws {
        var fields: [String: Any] = [:]
        if explicitNull {
            fields["ebookLocation"] = NSNull()
            fields["ebookProgress"] = NSNull()
        }
        let progress = try decode(fields)
        #expect(progress.ebookLocation == nil)
        #expect(progress.ebookProgress == nil)
    }

    @Test
    func incompatibleEbookTypesFailDecoding() {
        #expect(throws: DecodingError.self) { try decode(["ebookLocation": ["page": 12]]) }
        #expect(throws: DecodingError.self) { try decode(["ebookProgress": "not-a-number"]) }
    }

    @Test
    func ebookSelectionUsesPrimaryOrSelectedInode() {
        #expect(GetEbookFile.Request(libraryItemId: "item-1").path == "/api/items/item-1/ebook")
        let selected = GetEbookFile.Request(libraryItemId: "item-1", fileId: "inode-7")
        #expect(selected.path == "/api/items/item-1/ebook/inode-7")
    }

    private func jsonObject<Body: RequestBody>(_ body: Body) throws -> [String: Any] {
        let encoded = try body.encodeBody(using: RequestEncoder())
        return try #require(JSONSerialization.jsonObject(with: encoded.data) as? [String: Any])
    }

    private func decode(_ changes: [String: Any]) throws -> MediaProgress {
        var fields: [String: Any] = [
            "id": "record-1", "userId": "user-1", "libraryItemId": "item-1",
            "mediaItemId": "book-1", "mediaItemType": "book", "duration": 1_000,
            "currentTime": 300, "progress": 0.3, "isFinished": false,
            "hideFromContinueListening": false, "lastUpdate": 5_000, "startedAt": 1_000
        ]
        fields.merge(changes) { _, supplied in supplied }
        let data = try JSONSerialization.data(withJSONObject: fields)
        return try JSONDecoder().decode(MediaProgress.self, from: data)
    }
}
