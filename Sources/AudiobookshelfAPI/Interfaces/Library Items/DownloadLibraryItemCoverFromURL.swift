import Foundation
import RagnarNetworking

/// Downloads and selects cover artwork from a URL on 2.26.0+.
public struct DownloadLibraryItemCoverFromURL: Interface {

    public struct Request: InterfaceRequest {
        public let method: RequestMethod = .post
        public let path: String
        public let queryItems: [URLQueryItem]? = nil
        public let headers: [String: String]? = nil
        public let authentication: AuthenticationScheme? = .bearer
        public let body: Payload

        /// Creates a URL cover download.
        /// - Parameters:
        ///   - itemId: Required library-item ID.
        ///   - url: Required image URL, encoded as wire url.
        public init(itemId: String, url: String) {
            self.path = "/api/items/\(itemId)/cover"
            self.body = Payload(url: url)
        }

        public struct Payload: RequestBody, Encodable, Sendable {
            /// Required image URL.
            public let url: String
            public init(url: String) { self.url = url }
        }
    }

    public typealias Response = UploadLibraryItemCover.Response

    public enum AudiobookshelfError: Error, Sendable {
        case badRequest
        case forbidden
        case notFound
        case internalError
    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )

}
