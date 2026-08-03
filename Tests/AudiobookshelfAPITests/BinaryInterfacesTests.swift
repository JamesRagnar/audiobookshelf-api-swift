@testable import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

/// `ResponseContract` no longer distinguishes a no-body success from any other success; both are
/// `.success`, and it is the declared `Response` type (`Data`, here) that builds itself from
/// whatever bytes arrived, including none. `binary200DecodesRawBytes` and
/// `binary204NoContentReturnsEmptyData` below cover the actual decoding behavior.
@Suite
struct BinaryInterfacesTests {

    @Test
    func binaryInterfacesDeclare200AsSuccess() {
        expectSuccessCase(GetHLSStreamFile.self, statusCode: 200)
        expectSuccessCase(GetLibraryItemCover.self, statusCode: 200)
        expectSuccessCase(GetLibraryFile.self, statusCode: 200)
        expectSuccessCase(GetShareCover.self, statusCode: 200)
    }

    @Test
    func binaryInterfacesWithOptionalBodiesDeclare204AsSuccess() {
        expectSuccessCase(GetLibraryItemCover.self, statusCode: 204)
        expectSuccessCase(GetLibraryFile.self, statusCode: 204)
        expectSuccessCase(GetShareCover.self, statusCode: 204)
    }

    @Test
    func binary200DecodesRawBytes() throws {
        let payload = Data([0x01, 0x02, 0x03])
        let response = try makeResponse(statusCode: 200)

        do {
            let decoded = try GetHLSStreamFile.handle((data: payload, response: response))
            #expect(decoded == payload)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test
    func binary204NoContentReturnsEmptyData() throws {
        let response = try makeResponse(statusCode: 204)

        do {
            let decoded = try GetLibraryFile.handle((data: Data(), response: response))
            #expect(decoded.isEmpty)
        } catch {
            #expect(Bool(false))
        }
    }

    private func expectSuccessCase<T: Interface>(_ interface: T.Type, statusCode: Int) {
        let match = interface.responses.match(statusCode)
        #expect(match != nil)

        let isSuccess: Bool
        if let match {
            switch match {
            case .success:
                isSuccess = true

            case .failure:
                isSuccess = false
            }
        } else {
            isSuccess = false
        }

        #expect(isSuccess)
    }

    private func makeResponse(statusCode: Int) throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        ))
    }

}
