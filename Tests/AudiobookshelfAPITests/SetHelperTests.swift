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
    func joinedDefaultSeparatorIncludesAllValues() throws {
        let set: Set<TestToken> = [.alpha, .beta, .gamma]
        let joined = try #require(set.joined())
        let parts = Set(joined.split(separator: ",").map(String.init))
        #expect(parts == ["alpha", "beta", "gamma"])
    }

    @Test
    func joinedCustomSeparatorUsesProvidedSeparator() throws {
        let set: Set<TestToken> = [.alpha, .beta]
        let joined = try #require(set.joined(separator: "|"))
        #expect(joined.contains("|"))
        let parts = Set(joined.split(separator: "|").map(String.init))
        #expect(parts == ["alpha", "beta"])
    }

}
