@testable import AudiobookshelfAPI
import Testing

@Suite
struct SetHelperTests {

    private enum TestToken: String {
        case alpha
        case beta
        case gamma
    }

    @Test
    func joinedEmptyReturnsNil() {
        let set = Set<TestToken>()
        #expect(set.joined() == nil)
    }

    @Test
    func joinedSingleValue() {
        let set: Set<TestToken> = [.alpha]
        #expect(set.joined() == "alpha")
    }

    @Test
    func joinedDefaultSeparatorIncludesAllValues() {
        let set: Set<TestToken> = [.alpha, .beta, .gamma]
        let joined = set.joined()
        #expect(joined != nil)
        let parts = Set(joined!.split(separator: ",").map(String.init))
        #expect(parts == ["alpha", "beta", "gamma"])
    }

    @Test
    func joinedCustomSeparatorUsesProvidedSeparator() {
        let set: Set<TestToken> = [.alpha, .beta]
        let joined = set.joined(separator: "|")
        #expect(joined != nil)
        #expect(joined!.contains("|"))
        let parts = Set(joined!.split(separator: "|").map(String.init))
        #expect(parts == ["alpha", "beta"])
    }

}
