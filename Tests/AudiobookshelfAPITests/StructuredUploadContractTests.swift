@testable import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct StructuredUploadContractTests {

    @Test
    func coverMultipartContainsOneCoverPartWithExactBinaryBytes() throws {
        let bytes = Data([0, 255, 13, 10, 1])
        let request = try UploadLibraryItemCover.Request(
            itemId: "item-1", imageData: bytes, filename: "cover.jpg", contentType: "image/jpeg",
            boundaryGenerator: { "abs-cover" }
        )
        let parts = try parseMultipart(request.body.data, boundary: "abs-cover")
        #expect(parts.count == 1)
        #expect(parts.first?.headers == [
            "Content-Disposition: form-data; name=\"cover\"; filename=\"cover.jpg\"",
            "Content-Type: image/jpeg"
        ])
        #expect(parts.first?.data == bytes)
        try checkContentType(request, expected: "multipart/form-data; boundary=abs-cover")
    }

    @Test
    func backupMultipartContainsOneFilePartAndArchiveExtension() throws {
        let bytes = Data([80, 75, 0, 255])
        let request = try UploadBackup.Request(
            backupFile: bytes, filename: "backup.audiobookshelf",
            boundaryGenerator: { "abs-backup" }
        )
        let parts = try parseMultipart(request.body.data, boundary: "abs-backup")
        #expect(parts.count == 1)
        #expect(parts.first?.headers == [
            "Content-Disposition: form-data; name=\"file\"; filename=\"backup.audiobookshelf\"",
            "Content-Type: application/octet-stream"
        ])
        #expect(parts.first?.data == bytes)
        try checkContentType(request, expected: "multipart/form-data; boundary=abs-backup")
    }

    @Test
    func uploadFileRetainsFieldsFramingAndBytesAfterHelperExtraction() throws {
        let bytes = Data([0, 255, 10])
        let request = try UploadFile.Request(
            fileData: bytes, filename: "book.m4b", mimeType: "audio/mp4",
            libraryId: "library-1", folderId: "folder-1", title: "Book", author: "Author",
            boundaryGenerator: { "abs-file" }
        )
        let parts = try parseMultipart(request.body.data, boundary: "abs-file")
        #expect(parts.count == 5)
        #expect(parts[0].headers == ["Content-Disposition: form-data; name=\"library\""])
        #expect(parts[0].data == Data("library-1".utf8))
        #expect(parts[1].data == Data("folder-1".utf8))
        #expect(parts[2].data == Data("Book".utf8))
        #expect(parts[3].data == Data("Author".utf8))
        #expect(parts[4].headers == [
            "Content-Disposition: form-data; name=\"file\"; filename=\"book.m4b\"",
            "Content-Type: audio/mp4"
        ])
        #expect(parts[4].data == bytes)
    }

    @Test(arguments: ["../cover.jpg", "a/cover.jpg", "a\\cover.jpg", "cover\r\n.jpg",
                      "cover\".jpg", "", "cover.gif", "cover", "cover\u{0}.jpg"])
    func coverRejectsUnsafeOrUnsupportedFilenames(filename: String) {
        #expect(throws: UploadLibraryItemCover.Request.ValidationError.invalidFilename) {
            try UploadLibraryItemCover.Request(
                itemId: "item-1", imageData: Data([1]), filename: filename, contentType: "image/jpeg"
            )
        }
    }

    @Test(arguments: ["backup.zip", "backup.AUDIOBOOKSHELF", "../backup.audiobookshelf", ""])
    func backupRejectsWrongOrUnsafeExtension(filename: String) {
        #expect(throws: UploadBackup.Request.ValidationError.invalidFilename) {
            try UploadBackup.Request(backupFile: Data([1]), filename: filename)
        }
    }

    @Test(arguments: ["image/jpeg\r\nInjected: true", "image/jpeg; charset=utf-8", "", "image"])
    func uploadsRejectInvalidMIMEType(mime: String) {
        #expect(throws: UploadLibraryItemCover.Request.ValidationError.invalidMIMEType) {
            try UploadLibraryItemCover.Request(
                itemId: "item-1", imageData: Data([1]), filename: "cover.jpg", contentType: mime
            )
        }
        #expect(throws: UploadBackup.Request.ValidationError.invalidMIMEType) {
            try UploadBackup.Request(backupFile: Data([1]), filename: "backup.audiobookshelf", mimeType: mime)
        }
    }

    @Test
    func uploadsRejectEmptyData() {
        #expect(throws: UploadLibraryItemCover.Request.ValidationError.emptyFileData) {
            try UploadLibraryItemCover.Request(
                itemId: "item-1", imageData: Data(), filename: "cover.jpg", contentType: "image/jpeg"
            )
        }
        #expect(throws: UploadBackup.Request.ValidationError.emptyFileData) {
            try UploadBackup.Request(backupFile: Data(), filename: "backup.audiobookshelf")
        }
    }

    @Test
    func multipartRetriesCollisionsAndRejectsBoundaryExhaustion() throws {
        let generator = BoundarySequence(["abs-collision", "abs-safe"])
        let cover = try UploadLibraryItemCover.Request(
            itemId: "item-1", imageData: Data("abs-collision".utf8),
            filename: "cover.jpg", contentType: "image/jpeg", boundaryGenerator: { generator.next() }
        )
        #expect(cover.body.contentType == "multipart/form-data; boundary=abs-safe")
        #expect(generator.calls == 2)
        let exhausted = BoundarySequence(Array(repeating: "abs-collision", count: 8))
        #expect(throws: UploadBackup.Request.ValidationError.boundaryGenerationFailed) {
            try UploadBackup.Request(
                backupFile: Data("abs-collision".utf8), filename: "backup.audiobookshelf",
                boundaryGenerator: { exhausted.next() }
            )
        }
        #expect(exhausted.calls == 8)
        #expect(throws: UploadLibraryItemCover.Request.ValidationError.boundaryGenerationFailed) {
            try UploadLibraryItemCover.Request(
                itemId: "item-1", imageData: Data([1]), filename: "cover.jpg", contentType: "image/jpeg",
                boundaryGenerator: { "bad\r\nboundary" }
            )
        }
    }

    private func checkContentType<T: InterfaceRequest>(_ request: T, expected: String) throws {
        let configuration = ServerConfiguration(
            url: try #require(URL(string: "https://example.invalid")),
            defaultHeaders: ["cOnTeNt-TyPe": "application/json"]
        )
        let built = try URLRequest(
            interfaceRequest: request,
            context: RequestContext(configuration: configuration, credential: "token")
        )
        #expect(built.value(forHTTPHeaderField: "Content-Type") == expected)
    }

    private struct Part {
        let headers: [String]
        let data: Data
    }

    private func parseMultipart(_ data: Data, boundary: String) throws -> [Part] {
        let start = Data("--\(boundary)\r\n".utf8)
        let end = Data("--\(boundary)--\r\n".utf8)
        let separator = Data("\r\n--\(boundary)".utf8)
        let headerEnd = Data("\r\n\r\n".utf8)
        var remaining = data
        var parts: [Part] = []
        while remaining != end {
            try #require(remaining.starts(with: start))
            remaining.removeFirst(start.count)
            let headerRange = try #require(remaining.range(of: headerEnd))
            let headers = try #require(String(data: remaining[..<headerRange.lowerBound], encoding: .utf8))
                .components(separatedBy: "\r\n")
            remaining.removeFirst(headerRange.upperBound - remaining.startIndex)
            let nextBoundary = try #require(remaining.range(of: separator))
            parts.append(Part(headers: headers, data: Data(remaining[..<nextBoundary.lowerBound])))
            remaining.removeFirst(nextBoundary.lowerBound - remaining.startIndex + 2)
        }
        try #require(!parts.isEmpty)
        return parts
    }

}

private final class BoundarySequence: @unchecked Sendable {

    private let lock = NSLock()
    private let values: [String]
    private var index = 0

    init(_ values: [String]) { self.values = values }

    var calls: Int {
        lock.lock()
        defer { lock.unlock() }
        return index
    }

    func next() -> String {
        lock.lock()
        defer { lock.unlock() }
        let value = values[index]
        index += 1
        return value
    }

}
