@testable import AudiobookshelfAPI
import Testing

@Suite
struct BoolHelperTests {

    @Test
    func binaryStringTrue() {
        #expect(true.binaryString == "1")
    }

    @Test
    func binaryStringFalse() {
        #expect(false.binaryString == "0")
    }

}
