import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

/// Pins the status codes each interface's route middleware can raise.
///
/// Derived by matching every interface to its 2.36.0 route and reading the middleware in that
/// route's chain. The codes are conditional, so they were resolved per route rather than per
/// controller: several controllers raise `403` only on write methods, several guard their `404`
/// behind `req.params.id`, and `EmailController.adminMiddleware` answers `404` rather than `403`.
///
/// These were all missing before the 2.36.0 audit follow-up. Without them the client gets an untyped
/// `unknownResponseCase` instead of a typed error.
@Suite
struct MiddlewareStatusCodeCoverageTests {

    @Test
    func everyInterfaceMapsItsMiddlewareStatusCodes() throws {
        for (interface, codes) in Self.expectations {
            for code in codes {
                #expect(
                    interface.responseCases.match(code) != nil,
                    "\(interface) does not map middleware status \(code)"
                )
            }
        }
    }

    private static let expectations: [(any Interface.Type, [Int])] = [
        (CheckNewPodcastEpisodes.self, [500]),
        (ClearPodcastQueue.self, [403, 500]),
        (CloseFeed.self, [403]),
        (DeleteAuthorImage.self, [404]),
        (DeleteLibrary.self, [400]),
        (DeleteLibraryItem.self, [403]),
        (DeleteNotification.self, [403, 404]),
        (DeletePodcastEpisode.self, [500]),
        (DeleteSession.self, [403]),
        (DownloadPodcastEpisodes.self, [500]),
        (FireTestEvent.self, [403]),
        (GetAdminYearStats.self, [403]),
        (GetAllFeeds.self, [403]),
        (GetEbookFile.self, [403]),
        (GetEmailSettings.self, [404]),
        (GetLibraryAuthors.self, [400, 403, 404]),
        (GetLibraryCollections.self, [400, 403]),
        (GetLibraryNarrators.self, [400, 403, 404]),
        (GetLibraryOPML.self, [400, 403]),
        (GetLibrarySeriesById.self, [400, 403]),
        (GetLibraryUserPlaylists.self, [400, 403]),
        (GetNotificationData.self, [403]),
        (GetServerStats.self, [403]),
        (MatchAllLibraryItems.self, [400]),
        (MatchPodcastEpisodes.self, [403, 500]),
        (OpenFeedForCollection.self, [403]),
        (OpenFeedForSeries.self, [403]),
        (RemoveLibraryItemCover.self, [403]),
        (RemoveLibraryItemsWithIssues.self, [400]),
        (RemoveLibraryMetadataFiles.self, [400]),
        (RemoveLibraryNarrator.self, [400]),
        (ScanLibraryFolders.self, [400]),
        (ScanLibraryItem.self, [403]),
        (SearchPodcastEpisode.self, [403, 500]),
        (SendTestEmail.self, [404]),
        (TestNotification.self, [403, 404]),
        (UpdateEReaderDevices.self, [404]),
        (UpdateEmailSettings.self, [404]),
        (UpdateLibrary.self, [400]),
        (UpdateLibraryItemMedia.self, [403]),
        (UpdateNotification.self, [403, 404]),
        (UpdateSeries.self, [403]),
        (UploadAuthorImage.self, [404])
    ]

}
