//
//  GetYourListeningStats.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves your listening statistics.
public struct GetYourListeningStats: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/me/listening-stats"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Your Listening Stats Request
        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let totalTime: Double

        public let items: [String: ListenedItem]

        public let days: [String: Double]

        public let dayOfWeek: [String: Double]

        public let today: Double

        public let recentSessions: [PlaybackSession]

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200)
    )

}

public extension GetYourListeningStats.Response {

    struct ListenedItem: Sendable {

        /// The ID of the library item you listened to.
        public let id: String

        /// The time (in seconds) you listened to the library item.
        public let timeListening: Double

        /// The metadata of the library item's media.
        /// Can be either book or podcast metadata depending on the media type.
        public let mediaMetadata: MediaMetadata
    }

    enum MediaMetadata: Sendable {
        case book(BookMetadata)
        case podcast(PodcastMetadata)

        /// The book metadata, if this is a book
        public var book: BookMetadata? {
            if case .book(let metadata) = self {
                return metadata
            }
            return nil
        }

        /// The podcast metadata, if this is a podcast
        public var podcast: PodcastMetadata? {
            if case .podcast(let metadata) = self {
                return metadata
            }
            return nil
        }
    }

}

extension GetYourListeningStats.Response.ListenedItem: Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case timeListening
        case mediaMetadata
    }

    enum MediaMetadataCodingKeys: String, CodingKey {
        case author
        case feedUrl
        case imageUrl
        case itunesId
        case itunesPageUrl
        case itunesArtistId
        case releaseDate
        case type
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.timeListening = try container.decode(Double.self, forKey: .timeListening)

        let metadataDecoder = try container.superDecoder(forKey: .mediaMetadata)
        let metadataContainer = try metadataDecoder.container(keyedBy: MediaMetadataCodingKeys.self)

        if metadataContainer.contains(.author)
            || metadataContainer.contains(.feedUrl)
            || metadataContainer.contains(.imageUrl)
            || metadataContainer.contains(.itunesId)
            || metadataContainer.contains(.itunesPageUrl)
            || metadataContainer.contains(.itunesArtistId)
            || metadataContainer.contains(.releaseDate)
            || metadataContainer.contains(.type) {
            self.mediaMetadata = .podcast(
                try container.decode(PodcastMetadata.self, forKey: .mediaMetadata)
            )
        } else {
            self.mediaMetadata = .book(
                try container.decode(BookMetadata.self, forKey: .mediaMetadata)
            )
        }
    }

}
