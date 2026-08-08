import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct PersonalizedLibraryShelfDecodingTests {

    // MARK: Book shelf → entities decoded as LibraryItem

    @Test
    func bookShelfDecodesLibraryItemEntities() throws {
        let json = """
        [{
          "id": "shelf-recent",
          "label": "Recently Added",
          "labelStringKey": "recentlyAdded",
          "type": "book",
          "entities": [\(TestFixtures.bookLibraryItemJSON)]
        }]
        """
        let shelves = try decode(json)

        #expect(shelves.count == 1)
        let shelf = try #require(shelves.first)
        #expect(shelf.id == "shelf-recent")
        #expect(shelf.type == .book)
        #expect(shelf.entities.count == 1)

        guard case .libraryItem(let item) = shelf.entities.first else {
            Issue.record("Expected .libraryItem entity")
            return
        }
        #expect(item.id == "li-1")
        guard case .book = item.media else {
            Issue.record("Expected book media on library item")
            return
        }
    }

    // MARK: Podcast shelf → entities decoded as LibraryItem

    @Test
    func podcastShelfDecodesLibraryItemEntities() throws {
        let json = """
        [{
          "id": "shelf-podcasts",
          "label": "Latest Episodes",
          "labelStringKey": "latestEpisodes",
          "type": "podcast",
          "entities": [\(TestFixtures.podcastLibraryItemJSON)]
        }]
        """
        let shelves = try decode(json)
        let shelf = try #require(shelves.first)
        #expect(shelf.type == .podcast)

        guard case .libraryItem(let item) = shelf.entities.first else {
            Issue.record("Expected .libraryItem entity")
            return
        }
        guard case .podcast = item.media else {
            Issue.record("Expected podcast media")
            return
        }
    }

    // MARK: Episode shelf → entities decoded as LibraryItem

    @Test
    func episodeShelfDecodesLibraryItemEntities() throws {
        let json = """
        [{
          "id": "shelf-episodes",
          "label": "Recent Episodes",
          "labelStringKey": "recentEpisodes",
          "type": "episode",
          "entities": [\(TestFixtures.podcastLibraryItemJSON)]
        }]
        """
        let shelves = try decode(json)
        let shelf = try #require(shelves.first)
        #expect(shelf.type == .episode)
        guard case .libraryItem = shelf.entities.first else {
            Issue.record("Expected .libraryItem entity for episode shelf")
            return
        }
    }

    // MARK: Series shelf → entities decoded as Series

    @Test
    func seriesShelfDecodesSeriesEntities() throws {
        let json = """
        [{
          "id": "shelf-series",
          "label": "Continue Series",
          "labelStringKey": "continueSeries",
          "type": "series",
          "entities": [{
            "id": "series-1",
            "name": "The Expanse",
            "numBooks": 9
          }]
        }]
        """
        let shelves = try decode(json)
        let shelf = try #require(shelves.first)
        #expect(shelf.type == .series)
        #expect(shelf.entities.count == 1)

        guard case .series(let series) = shelf.entities.first else {
            Issue.record("Expected .series entity")
            return
        }
        #expect(series.id == "series-1")
        #expect(series.name == "The Expanse")
    }

    // MARK: Authors shelf → entities decoded as Author

    @Test
    func authorsShelfDecodesAuthorEntities() throws {
        let json = """
        [{
          "id": "shelf-authors",
          "label": "Recommended Authors",
          "labelStringKey": "recommendedAuthors",
          "type": "authors",
          "entities": [{
            "id": "author-1",
            "name": "Brandon Sanderson"
          }]
        }]
        """
        let shelves = try decode(json)
        let shelf = try #require(shelves.first)
        #expect(shelf.type == .authors)
        #expect(shelf.entities.count == 1)

        guard case .author(let author) = shelf.entities.first else {
            Issue.record("Expected .author entity")
            return
        }
        #expect(author.id == "author-1")
        #expect(author.name == "Brandon Sanderson")
    }

    // MARK: Helpers

    private func decode(_ json: String) throws -> [GetPersonalizedLibrary.Shelf] {
        try JSONDecoder().decode([GetPersonalizedLibrary.Shelf].self, from: Data(json.utf8))
    }

}
