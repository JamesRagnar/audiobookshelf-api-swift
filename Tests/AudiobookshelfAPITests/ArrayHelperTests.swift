@testable import AudiobookshelfAPI
import Foundation
import Testing

extension Array where Element == URLQueryItem {

    subscript(name: String) -> String? {
        first(where: { $0.name == name })?.value
    }

}

@Suite
struct ArrayHelperTests {

    @Test
    func appendIfPresentInsertsValue() {
        var items: [URLQueryItem] = []
        items.appendIfPresent("key", "value")
        #expect(items == [URLQueryItem(name: "key", value: "value")])
    }

    @Test
    func appendIfPresentSkipsNil() {
        var items: [URLQueryItem] = []
        items.appendIfPresent("key", nil)
        #expect(items.isEmpty)
    }

    @Test
    func appendIfPresentDoesNotSkipDuplicateKeys() {
        var items: [URLQueryItem] = [URLQueryItem(name: "key", value: "value")]
        items.appendIfPresent("key", "value2")
        #expect(items == [
            URLQueryItem(name: "key", value: "value"),
            URLQueryItem(name: "key", value: "value2")
        ])
    }

}
