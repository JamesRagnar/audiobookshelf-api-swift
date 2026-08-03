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

        public let totalTime: Int

        public let items: [String: ListenedItem]

        public let days: [String: Int]

        public let dayOfWeek: [String: Int]

        public let today: Int

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
        public let timeListening: Int

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

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.timeListening = try container.decode(Int.self, forKey: .timeListening)

        // Decode metadata polymorphically
        let metadataDecoder = try container.superDecoder(forKey: .mediaMetadata)

        // Try to decode as BookMetadata first (has unique fields like isbn, authors array)
        if let bookMetadata = try? BookMetadata(from: metadataDecoder) {
            // Additional check: BookMetadata has 'authors' array or 'isbn' field
            // PodcastMetadata has 'feedUrl' or 'author' (string, not array)
            self.mediaMetadata = .book(bookMetadata)
        } else if let podcastMetadata = try? PodcastMetadata(from: metadataDecoder) {
            self.mediaMetadata = .podcast(podcastMetadata)
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unable to decode mediaMetadata as either BookMetadata or PodcastMetadata"
                )
            )
        }
    }

}
