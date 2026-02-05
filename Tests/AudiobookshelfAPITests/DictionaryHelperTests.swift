@testable import AudiobookshelfAPI
import Testing

@Suite
struct DictionaryHelperTests {

    @Test
    func setIfPresentInsertsValue() {
        var dict: [String: String?] = [:]
        dict.setIfPresent("key", "value")
        #expect(dict["key"] == "value")
    }

    @Test
    func setIfPresentSkipsNil() {
        var dict: [String: String?] = [:]
        dict.setIfPresent("key", nil)
        #expect(dict["key"] == nil)
    }

    @Test
    func setIfPresentDoesNotOverwriteWithNil() {
        var dict: [String: String?] = ["key": "value"]
        dict.setIfPresent("key", nil)
        #expect(dict["key"] == "value")
    }

}
