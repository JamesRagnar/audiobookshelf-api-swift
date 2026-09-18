@testable import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct UploadFileTests {

    @Test
    func structuredInitializerBuildsMultipartAndPreservesBytes() throws {
        let bytes = Data([0, 1, 2, 255, 10])
        let request = try UploadFile.Request(
            fileData: bytes,
            filename: "book.m4b",
            mimeType: "audio/mp4",
            libraryId: "library-1",
            folderId: "folder-1",
            title: "A Title",
            author: "An Author",
            series: "A Series"
        )

        #expect(request.body.contentType.hasPrefix("multipart/form-data; boundary=abs-"))
        #expect(request.headers?["Content-Type"] == request.body.contentType)
        #expect(request.body.data.range(of: bytes) != nil)
        #expect(request.body.data.range(of: Data("name=\"library\"\r\n\r\nlibrary-1".utf8)) != nil)
        #expect(request.body.data.range(of: Data("name=\"folder\"\r\n\r\nfolder-1".utf8)) != nil)
        #expect(request.body.data.range(of: Data("name=\"title\"\r\n\r\nA Title".utf8)) != nil)
        #expect(request.body.data.range(of: Data("filename=\"book.m4b\"\r\nContent-Type: audio/mp4".utf8)) != nil)
        #expect(request.body.data.range(of: Data("\r\n--".utf8)) != nil)
    }

    @Test
    func structuredRequestOverridesConflictingDefaultContentType() throws {
        let request = try UploadFile.Request(
            fileData: Data([1, 2, 3]),
            filename: "book.m4b",
            mimeType: "audio/mp4",
            libraryId: "library-1",
            folderId: "folder-1",
            title: "A Title"
        )
        let configuration = ServerConfiguration(
            url: try #require(URL(string: "https://example.com/abs/")),
            defaultHeaders: ["content-type": "application/json"]
        )
        let built = try URLRequest(
            interfaceRequest: request,
            context: RequestContext(configuration: configuration, credential: "token")
        )

        #expect(built.value(forHTTPHeaderField: "Content-Type") == request.body.contentType)
    }

    @Test
    func structuredRequestOverridesIncorrectMultipartBoundaryDefaults() throws {
        let request = try UploadFile.Request(
            fileData: Data([1, 2, 3]),
            filename: "book.m4b",
            mimeType: "audio/mp4",
            libraryId: "library-1",
            folderId: "folder-1",
            title: "A Title"
        )
        let configuration = ServerConfiguration(
            url: try #require(URL(string: "https://example.com")),
            defaultHeaders: ["cOnTeNt-TyPe": "multipart/form-data; boundary=wrong"]
        )
        let built = try URLRequest(
            interfaceRequest: request,
            context: RequestContext(configuration: configuration, credential: "token")
        )

        #expect(built.value(forHTTPHeaderField: "Content-Type") == request.body.contentType)
    }

    @Test
    func boundaryGeneratorRegeneratesWhenContentContainsBoundary() throws {
        let generator = TestBoundaryGenerator(values: ["abs-collision", "abs-safe"])
        let request = try UploadFile.Request(
            fileData: Data("abs-collision".utf8),
            filename: "book.m4b",
            mimeType: "audio/mp4",
            libraryId: "library",
            folderId: "folder",
            title: "title",
            boundaryGenerator: { @Sendable in generator.next() }
        )

        #expect(request.body.contentType == "multipart/form-data; boundary=abs-safe")
    }

    @Test(arguments: [
        ("", UploadFile.Request.ValidationError.invalidLibraryID),
        ("   ", UploadFile.Request.ValidationError.invalidLibraryID)
    ])
    func structuredInitializerRejectsInvalidLibraryID(
        value: String,
        expected: UploadFile.Request.ValidationError
    ) {
        #expect(throws: expected) {
            try UploadFile.Request(
                fileData: Data([1]), filename: "book.m4b", mimeType: "audio/mp4",
                libraryId: value, folderId: "folder", title: "title"
            )
        }
    }

    @Test
    func structuredInitializerRejectsUnsafeFilenameAndMIME() {
        #expect(throws: UploadFile.Request.ValidationError.invalidFilename) {
            try UploadFile.Request(
                fileData: Data([1]), filename: "../book.m4b", mimeType: "audio/mp4",
                libraryId: "library", folderId: "folder", title: "title"
            )
        }
        #expect(throws: UploadFile.Request.ValidationError.invalidMIMEType) {
            try UploadFile.Request(
                fileData: Data([1]), filename: "book.m4b", mimeType: "audio/mp4; charset=utf-8",
                libraryId: "library", folderId: "folder", title: "title"
            )
        }
    }

}

private final class TestBoundaryGenerator: @unchecked Sendable {

    private var values: [String]

    init(values: [String]) {
        self.values = values
    }

    func next() -> String {
        values.removeFirst()
    }

}
