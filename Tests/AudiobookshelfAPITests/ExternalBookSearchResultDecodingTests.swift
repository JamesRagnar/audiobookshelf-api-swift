import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct ExternalBookSearchResultDecodingTests {

    @Test
    func publishedYearDecodesFromString() throws {
        let result = try decode(
            """
            {
              "title": "Book",
              "publishedYear": "2024"
            }
            """
        )

        #expect(result.publishedYear == "2024")
    }

    @Test
    func publishedYearDecodesFromInt() throws {
        let result = try decode(
            """
            {
              "title": "Book",
              "publishedYear": 2024
            }
            """
        )

        #expect(result.publishedYear == "2024")
    }

    @Test
    func tagsDecodeFromArray() throws {
        let result = try decode(
            """
            {
              "title": "Book",
              "tags": ["fantasy", "epic"]
            }
            """
        )

        #expect(result.tags == ["fantasy", "epic"])
    }

    @Test
    func tagsDecodeFromCommaSeparatedStringAndTrimWhitespace() throws {
        let result = try decode(
            """
            {
              "title": "Book",
              "tags": "fantasy, epic,  long-form "
            }
            """
        )

        #expect(result.tags == ["fantasy", "epic", "long-form"])
    }

    @Test
    func seriesMatchDecodesFromSeriesKey() throws {
        let result = try decode(
            """
            {
              "title": "Book",
              "series": [
                {
                  "series": "Stormlight Archive",
                  "sequence": "1"
                }
              ]
            }
            """
        )

        let series = try #require(result.series)
        #expect(series.count == 1)
        #expect(series.first?.name == "Stormlight Archive")
        #expect(series.first?.sequence == "1")
    }

    private func decode(_ json: String) throws -> ExternalBookSearchResult {
        try JSONDecoder().decode(ExternalBookSearchResult.self, from: Data(json.utf8))
    }
}
