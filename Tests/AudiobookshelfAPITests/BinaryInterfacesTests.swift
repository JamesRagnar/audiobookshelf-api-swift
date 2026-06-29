@testable import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct BinaryInterfacesTests {

    @Test
    func binaryInterfacesKeepDecodeFor200() {
        expectDecodeCase(GetHLSStreamFile.self)
        expectDecodeCase(GetLibraryItemCover.self)
        expectDecodeCase(GetLibraryFile.self)
        expectDecodeCase(GetShareCover.self)
    }

    @Test
    func binaryInterfacesWithOptionalBodiesKeepNoContentFor204() {
        expectNoContentCase(GetLibraryItemCover.self, statusCode: 204)
        expectNoContentCase(GetLibraryFile.self, statusCode: 204)
        expectNoContentCase(GetShareCover.self, statusCode: 204)
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

    private func expectDecodeCase<T: Interface>(_ interface: T.Type) {
        let outcome = interface.responseCases.match(200)
        #expect(outcome != nil)

        let isDecode: Bool
        if let outcome {
            switch outcome {
            case .decode:
                isDecode = true

            default:
                isDecode = false
            }
        } else {
            isDecode = false
        }

        #expect(isDecode)
    }

    private func expectNoContentCase<T: Interface>(_ interface: T.Type, statusCode: Int) {
        let outcome = interface.responseCases.match(statusCode)
        #expect(outcome != nil)

        let isNoContent: Bool
        if let outcome {
            switch outcome {
            case .noContent:
                isNoContent = true

            default:
                isNoContent = false
            }
        } else {
            isNoContent = false
        }

        #expect(isNoContent)
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
