import AudiobookshelfAPI
import RagnarNetworking
import Testing

/// Pins typed failures verified against the server's route handlers and middleware.
@Suite
struct InterfaceFailureContractTests {

    @Test
    func everyInterfaceMapsExpectedDomainErrors() {
        for expectation in interfaceFailureExpectations {
            for code in expectation.codes {
                #expect(
                    expectation.matches(code),
                    "\(expectation.description) does not map status \(code) to the expected domain error"
                )
            }
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

private func expectation<T: Interface, E: Error & Sendable>(
    _ type: T.Type,
    _ expectedErrors: [Int: E]
) -> Expectation {
    Expectation(
        description: String(describing: type),
        matches: { code in
            guard
                let expectedError = expectedErrors[code],
                case .failure(.error(let actualError)) = type.responses.match(code)
            else {
                return false
            }

            return actualError is E
                && String(describing: actualError) == String(describing: expectedError)
        },
        codes: expectedErrors.keys.sorted()
    )
}

private let interfaceFailureExpectations: [Expectation] = [
    expectation(
        CheckNewPodcastEpisodes.self,
        [
            500: CheckNewPodcastEpisodes.AudiobookshelfError.internalServerError
        ]
    ),
    expectation(
        ClearPodcastQueue.self,
        [
            403: ClearPodcastQueue.AudiobookshelfError.forbidden,
            500: .internalServerError
        ]
    ),
    expectation(CloseOpenSession.self, [403: CloseOpenSession.AudiobookshelfError.forbidden]),
    expectation(CloseFeed.self, [403: CloseFeed.AudiobookshelfError.forbidden]),
    expectation(CreateAPIKey.self, [500: CreateAPIKey.AudiobookshelfError.internalServerError]),
    expectation(
        CreateBookmark.self,
        [
            400: CreateBookmark.AudiobookshelfError.badRequest,
            403: .forbidden,
            404: .notFound
        ]
    ),
    expectation(CreateUser.self, [500: CreateUser.AudiobookshelfError.internalServerError]),
    expectation(DeleteAuthorImage.self, [404: DeleteAuthorImage.AudiobookshelfError.notFound]),
    expectation(
        DeleteBookmark.self,
        [
            400: DeleteBookmark.AudiobookshelfError.badRequest,
            403: .forbidden,
            404: .notFound
        ]
    ),
    expectation(DeleteLibrary.self, [400: DeleteLibrary.AudiobookshelfError.badRequest]),
    expectation(DeleteLibraryItem.self, [403: DeleteLibraryItem.AudiobookshelfError.forbidden]),
    expectation(DeleteNotification.self, [403: DeleteNotification.AudiobookshelfError.forbidden, 404: .notFound]),
    expectation(DeletePodcastEpisode.self, [500: DeletePodcastEpisode.AudiobookshelfError.internalServerError]),
    expectation(DeleteSession.self, [403: DeleteSession.AudiobookshelfError.forbidden]),
    expectation(DeleteUser.self, [400: DeleteUser.AudiobookshelfError.badRequest, 403: .forbidden, 404: .notFound]),
    expectation(
        DeleteYourAuthSession.self,
        [400: DeleteYourAuthSession.AudiobookshelfError.badRequest, 403: .forbidden, 404: .notFound]
    ),
    expectation(
        DownloadPodcastEpisodes.self,
        [
            500: DownloadPodcastEpisodes.AudiobookshelfError.internalServerError
        ]
    ),
    expectation(FireTestEvent.self, [403: FireTestEvent.AudiobookshelfError.forbidden]),
    expectation(GetAdminYearStats.self, [403: GetAdminYearStats.AudiobookshelfError.forbidden]),
    expectation(GetAllFeeds.self, [403: GetAllFeeds.AudiobookshelfError.forbidden]),
    expectation(GetAllSessions.self, [404: GetAllSessions.AudiobookshelfError.notFound]),
    expectation(GetEbookFile.self, [403: GetEbookFile.AudiobookshelfError.forbidden]),
    expectation(GetEmailSettings.self, [404: GetEmailSettings.AudiobookshelfError.notFound]),
    expectation(
        GetItemListeningSessions.self,
        [
            403: GetItemListeningSessions.AudiobookshelfError.forbidden,
            404: .notFound
        ]
    ),
    expectation(GetLibrary.self, [400: GetLibrary.AudiobookshelfError.badRequest, 403: .forbidden, 404: .notFound]),
    expectation(
        GetLibraryAuthors.self,
        [
            400: GetLibraryAuthors.AudiobookshelfError.badRequest,
            403: .forbidden,
            404: .notFound
        ]
    ),
    expectation(
        GetLibraryCollections.self,
        [
            400: GetLibraryCollections.AudiobookshelfError.badRequest,
            403: .forbidden
        ]
    ),
    expectation(
        GetLibraryEpisodeDownloadQueue.self,
        [400: GetLibraryEpisodeDownloadQueue.AudiobookshelfError.badRequest, 403: .forbidden, 404: .notFound]
    ),
    expectation(
        GetLibraryFilterData.self,
        [
            400: GetLibraryFilterData.AudiobookshelfError.badRequest,
            403: .forbidden,
            404: .notFound
        ]
    ),
    expectation(GetLibraryItem.self, [403: GetLibraryItem.AudiobookshelfError.forbidden, 404: .notFound]),
    expectation(
        GetLibraryItemCover.self,
        [
            404: GetLibraryItemCover.AudiobookshelfError.notFound,
            500: .internalServerError
        ]
    ),
    expectation(
        GetLibraryItems.self,
        [
            400: GetLibraryItems.AudiobookshelfError.badRequest,
            403: .forbidden,
            404: .notFound
        ]
    ),
    expectation(
        GetLibraryNarrators.self,
        [
            400: GetLibraryNarrators.AudiobookshelfError.badRequest,
            403: .forbidden,
            404: .notFound
        ]
    ),
    expectation(GetLibraryOPML.self, [400: GetLibraryOPML.AudiobookshelfError.badRequest, 403: .forbidden]),
    expectation(
        GetLibraryPodcastTitles.self,
        [400: GetLibraryPodcastTitles.AudiobookshelfError.badRequest, 403: .forbidden, 404: .notFound]
    ),
    expectation(
        GetLibrarySeries.self,
        [
            400: GetLibrarySeries.AudiobookshelfError.badRequest,
            403: .forbidden,
            404: .notFound
        ]
    ),
    expectation(
        GetLibrarySeriesById.self,
        [
            400: GetLibrarySeriesById.AudiobookshelfError.badRequest,
            403: .forbidden
        ]
    ),
    expectation(
        GetLibraryStats.self,
        [
            400: GetLibraryStats.AudiobookshelfError.badRequest,
            403: .forbidden,
            404: .notFound
        ]
    ),
    expectation(
        GetLibraryUserPlaylists.self,
        [
            400: GetLibraryUserPlaylists.AudiobookshelfError.badRequest,
            403: .forbidden
        ]
    ),
    expectation(GetNotificationData.self, [403: GetNotificationData.AudiobookshelfError.forbidden]),
    expectation(GetOpenSession.self, [403: GetOpenSession.AudiobookshelfError.forbidden]),
    expectation(GetOpenSessions.self, [404: GetOpenSessions.AudiobookshelfError.notFound]),
    expectation(
        GetPersonalizedLibrary.self,
        [400: GetPersonalizedLibrary.AudiobookshelfError.badRequest, 403: .forbidden, 404: .notFound]
    ),
    expectation(
        GetPodcastDownloadQueue.self,
        [403: GetPodcastDownloadQueue.AudiobookshelfError.forbidden, 404: .notFound, 500: .internalServerError]
    ),
    expectation(
        GetRecentEpisodes.self,
        [
            400: GetRecentEpisodes.AudiobookshelfError.badRequest,
            403: .forbidden,
            404: .notFound
        ]
    ),
    expectation(GetSearchProviders.self, [404: GetSearchProviders.AudiobookshelfError.notFound]),
    expectation(GetServerStats.self, [403: GetServerStats.AudiobookshelfError.forbidden]),
    expectation(
        GetYourBookmarksForLibraryItem.self,
        [403: GetYourBookmarksForLibraryItem.AudiobookshelfError.forbidden, 404: .notFound]
    ),
    expectation(MatchAllLibraryItems.self, [400: MatchAllLibraryItems.AudiobookshelfError.badRequest]),
    expectation(
        MatchPodcastEpisodes.self,
        [
            403: MatchPodcastEpisodes.AudiobookshelfError.forbidden,
            500: .internalServerError
        ]
    ),
    expectation(OpenFeedForCollection.self, [403: OpenFeedForCollection.AudiobookshelfError.forbidden]),
    expectation(OpenFeedForSeries.self, [403: OpenFeedForSeries.AudiobookshelfError.forbidden]),
    expectation(PatchMediaProgress.self, [400: PatchMediaProgress.AudiobookshelfError.badRequest, 404: .notFound]),
    expectation(RemoveLibraryItemCover.self, [403: RemoveLibraryItemCover.AudiobookshelfError.forbidden]),
    expectation(
        RemoveLibraryItemsWithIssues.self,
        [
            400: RemoveLibraryItemsWithIssues.AudiobookshelfError.badRequest
        ]
    ),
    expectation(RemoveLibraryMetadataFiles.self, [400: RemoveLibraryMetadataFiles.AudiobookshelfError.badRequest]),
    expectation(RemoveLibraryNarrator.self, [400: RemoveLibraryNarrator.AudiobookshelfError.badRequest]),
    expectation(RemoveMediaProgress.self, [404: RemoveMediaProgress.AudiobookshelfError.notFound]),
    expectation(ScanLibraryFolders.self, [400: ScanLibraryFolders.AudiobookshelfError.badRequest]),
    expectation(ScanLibraryItem.self, [403: ScanLibraryItem.AudiobookshelfError.forbidden]),
    expectation(
        SearchExternalAuthors.self,
        [
            400: SearchExternalAuthors.AudiobookshelfError.badRequest,
            500: .internalServerError
        ]
    ),
    expectation(
        SearchLibrary.self,
        [
            400: SearchLibrary.AudiobookshelfError.badRequest,
            403: .forbidden,
            404: .notFound
        ]
    ),
    expectation(
        SearchPodcastEpisode.self,
        [
            403: SearchPodcastEpisode.AudiobookshelfError.forbidden,
            500: .internalServerError
        ]
    ),
    expectation(
        SendTestEmail.self,
        [
            400: SendTestEmail.AudiobookshelfError.badRequest,
            403: .forbidden,
            404: .notFound
        ]
    ),
    expectation(SyncOpenSession.self, [403: SyncOpenSession.AudiobookshelfError.forbidden]),
    expectation(TestNotification.self, [403: TestNotification.AudiobookshelfError.forbidden, 404: .notFound]),
    expectation(
        UpdateAuthor.self,
        [
            400: UpdateAuthor.AudiobookshelfError.badRequest,
            403: .forbidden,
            404: .notFound
        ]
    ),
    expectation(
        UpdateBookmark.self,
        [
            400: UpdateBookmark.AudiobookshelfError.badRequest,
            403: .forbidden,
            404: .notFound
        ]
    ),
    expectation(UpdateEReaderDevices.self, [404: UpdateEReaderDevices.AudiobookshelfError.notFound]),
    expectation(UpdateEmailSettings.self, [404: UpdateEmailSettings.AudiobookshelfError.notFound]),
    expectation(UpdateLibrary.self, [400: UpdateLibrary.AudiobookshelfError.badRequest]),
    expectation(UpdateLibraryItemMedia.self, [403: UpdateLibraryItemMedia.AudiobookshelfError.forbidden]),
    expectation(UpdateNotification.self, [403: UpdateNotification.AudiobookshelfError.forbidden, 404: .notFound]),
    expectation(UpdateNotificationSettings.self, [403: UpdateNotificationSettings.AudiobookshelfError.forbidden]),
    expectation(UpdatePassword.self, [400: UpdatePassword.AudiobookshelfError.badRequest, 403: .forbidden]),
    expectation(
        UpdatePodcastEpisode.self,
        [403: UpdatePodcastEpisode.AudiobookshelfError.forbidden, 404: .notFound, 500: .internalServerError]
    ),
    expectation(UpdateSeries.self, [403: UpdateSeries.AudiobookshelfError.forbidden]),
    expectation(UploadAuthorImage.self, [404: UploadAuthorImage.AudiobookshelfError.notFound]),
    expectation(ValidateCronExpression.self, [400: ValidateCronExpression.AudiobookshelfError.badRequest])
]
