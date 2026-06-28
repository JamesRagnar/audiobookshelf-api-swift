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
          "entities": [\(bookLibraryItemJSON)]
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
          "entities": [\(podcastLibraryItemJSON)]
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
          "entities": [\(podcastLibraryItemJSON)]
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

    // MARK: Optional category field

    @Test
    func categoryIsOptional() throws {
        let withCategory = """
        [{
          "id": "shelf-1",
          "label": "New",
          "labelStringKey": "new",
          "type": "book",
          "entities": [],
          "category": "recentlyAdded"
        }]
        """
        let withoutCategory = """
        [{
          "id": "shelf-2",
          "label": "New",
          "labelStringKey": "new",
          "type": "book",
          "entities": []
        }]
        """
        let shelvesWithCategory = try decode(withCategory)
        let shelvesWithoutCategory = try decode(withoutCategory)
        #expect(shelvesWithCategory.first?.category == "recentlyAdded")
        #expect(shelvesWithoutCategory.first?.category == nil)
    }

    // MARK: Multiple shelves

    @Test
    func multipleShelvesDecodeInOrder() throws {
        let json = """
        [
          {
            "id": "shelf-1",
            "label": "Books",
            "labelStringKey": "books",
            "type": "book",
            "entities": []
          },
          {
            "id": "shelf-2",
            "label": "Authors",
            "labelStringKey": "authors",
            "type": "authors",
            "entities": []
          }
        ]
        """
        let shelves = try decode(json)
        #expect(shelves.count == 2)
        #expect(shelves[0].id == "shelf-1")
        #expect(shelves[1].id == "shelf-2")
    }

    // MARK: Helpers

    private func decode(_ json: String) throws -> [GetPersonalizedLibrary.Shelf] {
        try JSONDecoder().decode([GetPersonalizedLibrary.Shelf].self, from: Data(json.utf8))
    }

}

// MARK: Fixtures

private let bookLibraryItemJSON = """
{
  "id": "li-1",
  "ino": "111",
  "libraryId": "lib-1",
  "folderId": "folder-1",
  "path": "/books/test",
  "relPath": "test",
  "isFile": false,
  "addedAt": 1000,
  "updatedAt": 2000,
  "isMissing": false,
  "isInvalid": false,
  "mediaType": "book",
  "media": {
    "id": "book-1",
    "metadata": { "title": "Test Book", "genres": [] },
    "tags": []
  }
}
"""

private let podcastLibraryItemJSON = """
{
  "id": "li-2",
  "ino": "222",
  "libraryId": "lib-1",
  "folderId": "folder-1",
  "path": "/podcasts/test",
  "relPath": "test",
  "isFile": false,
  "addedAt": 1000,
  "updatedAt": 2000,
  "isMissing": false,
  "isInvalid": false,
  "mediaType": "podcast",
  "media": {
    "id": "podcast-1",
    "metadata": { "title": "Test Podcast", "genres": [] },
    "tags": [],
    "autoDownloadEpisodes": false,
    "maxEpisodesToKeep": 0,
    "maxNewEpisodesToDownload": 0
  }
}
"""
