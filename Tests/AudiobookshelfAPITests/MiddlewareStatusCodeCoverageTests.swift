import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

/// Pins the status codes each interface's route middleware can raise, as of 2.36.0.
///
/// The codes are conditional and resolved per route, not per controller: several controllers raise
/// `403` only on write methods, several guard their `404` behind `req.params.id`, and
/// `EmailController.adminMiddleware` answers `404` rather than `403`.
@Suite
struct MiddlewareStatusCodeCoverageTests {

    @Test
    func everyInterfaceMapsItsMiddlewareStatusCodes() throws {
        for expectation in Self.expectations {
            for code in expectation.codes {
                #expect(
                    expectation.matches(code),
                    "\(expectation.description) does not map middleware status \(code)"
                )
            }
        }
    }

    /// `ResponseContract<Response>` is generic over each Interface's own `Response` type, so a
    /// heterogeneous list cannot read `.responses` through `any Interface.Type` directly
    /// (existential member access cannot depend on an associated type). Each entry closes over
    /// its concrete Interface at declaration time instead, where `T` is still concrete.
    private struct Expectation {
        let description: String
        let matches: (Int) -> Bool
        let codes: [Int]
    }

    private static func expectation<T: Interface>(_ type: T.Type, _ codes: [Int]) -> Expectation {
        Expectation(
            description: String(describing: type),
            matches: { code in type.responses.match(code) != nil },
            codes: codes
        )
    }

    private static let expectations: [Expectation] = [
        expectation(CheckNewPodcastEpisodes.self, [500]),
        expectation(ClearPodcastQueue.self, [403, 500]),
        expectation(CloseFeed.self, [403]),
        expectation(DeleteAuthorImage.self, [404]),
        expectation(DeleteLibrary.self, [400]),
        expectation(DeleteLibraryItem.self, [403]),
        expectation(DeleteNotification.self, [403, 404]),
        expectation(DeletePodcastEpisode.self, [500]),
        expectation(DeleteSession.self, [403]),
        expectation(DownloadPodcastEpisodes.self, [500]),
        expectation(FireTestEvent.self, [403]),
        expectation(GetAdminYearStats.self, [403]),
        expectation(GetAllFeeds.self, [403]),
        expectation(GetEbookFile.self, [403]),
        expectation(GetEmailSettings.self, [404]),
        expectation(GetLibraryAuthors.self, [400, 403, 404]),
        expectation(GetLibraryCollections.self, [400, 403]),
        expectation(GetLibraryNarrators.self, [400, 403, 404]),
        expectation(GetLibraryOPML.self, [400, 403]),
        expectation(GetLibrarySeriesById.self, [400, 403]),
        expectation(GetLibraryUserPlaylists.self, [400, 403]),
        expectation(GetNotificationData.self, [403]),
        expectation(GetServerStats.self, [403]),
        expectation(MatchAllLibraryItems.self, [400]),
        expectation(MatchPodcastEpisodes.self, [403, 500]),
        expectation(OpenFeedForCollection.self, [403]),
        expectation(OpenFeedForSeries.self, [403]),
        expectation(RemoveLibraryItemCover.self, [403]),
        expectation(RemoveLibraryItemsWithIssues.self, [400]),
        expectation(RemoveLibraryMetadataFiles.self, [400]),
        expectation(RemoveLibraryNarrator.self, [400]),
        expectation(ScanLibraryFolders.self, [400]),
        expectation(ScanLibraryItem.self, [403]),
        expectation(SearchPodcastEpisode.self, [403, 500]),
        expectation(SendTestEmail.self, [404]),
        expectation(TestNotification.self, [403, 404]),
        expectation(UpdateEReaderDevices.self, [404]),
        expectation(UpdateEmailSettings.self, [404]),
        expectation(UpdateLibrary.self, [400]),
        expectation(UpdateLibraryItemMedia.self, [403]),
        expectation(UpdateNotification.self, [403, 404]),
        expectation(UpdateSeries.self, [403]),
        expectation(UploadAuthorImage.self, [404])
    ]

}
