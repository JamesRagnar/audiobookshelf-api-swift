import AudiobookshelfAPI
import Foundation
import RagnarNetworking

/// Test-only convenience restoring the single-argument `handle` call these compliance and
/// contract tests are written against. Production code goes through `RequestPipeline`, which
/// threads the client's actual `ResponseContext` and configured `ResponseHandler`; these tests
/// exercise response decoding in isolation, so a plain decoder and `DefaultResponseHandler` are
/// the right stand-ins here.
extension Interface {

    static func handle(
        _ response: (data: Data, response: URLResponse)
    ) throws(ResponseError) -> Response {
        try DefaultResponseHandler().handle(
            response,
            for: Self.self,
            context: ResponseContext(responseDecoder: ResponseDecoder())
        )
    }

}
