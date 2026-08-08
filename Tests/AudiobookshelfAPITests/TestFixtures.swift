enum TestFixtures {

    static let bookLibraryItemJSON = """
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

    static let podcastLibraryItemJSON = """
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

}
