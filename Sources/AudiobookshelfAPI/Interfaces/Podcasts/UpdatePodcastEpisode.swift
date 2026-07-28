//
//  UpdatePodcastEpisode.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update podcast episode metadata.
///
/// Only the fields you supply are sent, and the server only applies the fields it recognizes. The
/// response is the full expanded library item, not the episode.
public struct UpdatePodcastEpisode: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Update Podcast Episode Parameters
        ///
        /// - Parameters:
        ///   - podcastId: The ID of the podcast library item.
        ///   - episodeId: The ID of the episode.
        ///   - title: Episode title (optional).
        ///   - subtitle: Episode subtitle (optional).
        ///   - description: Episode description (optional).
        ///   - enclosure: Episode enclosure change (optional). Pass `.set` to replace the enclosure or
        ///     `.clear` to remove it. Requires server `>= 2.36.0`; older servers ignore the field.
        ///   - pubDate: Publication date (optional).
        ///   - season: Season identifier (optional).
        ///   - episode: Episode number (optional).
        ///   - episodeType: Episode type (optional).
        ///   - publishedAt: Publication timestamp (optional).
        public init(
            podcastId: String,
            episodeId: String,
            title: String? = nil,
            subtitle: String? = nil,
            description: String? = nil,
            enclosure: EnclosureUpdate? = nil,
            pubDate: String? = nil,
            season: String? = nil,
            episode: String? = nil,
            episodeType: String? = nil,
            publishedAt: Int? = nil
        ) {
            self.path = "/api/podcasts/\(podcastId)/episode/\(episodeId)"
            self.body = Payload(
                title: title,
                subtitle: subtitle,
                description: description,
                enclosure: enclosure,
                pubDate: pubDate,
                season: season,
                episode: episode,
                episodeType: episodeType,
                publishedAt: publishedAt
            )
        }

    }

    // MARK: Response

    /// The expanded library item the episode belongs to.
    ///
    /// The server responds with the whole item rather than the updated episode, matching
    /// `DeletePodcastEpisode`.
    public typealias Response = LibraryItem

    public enum AudiobookshelfError: Error, Sendable {
        case forbidden
        case notFound

        /// The library item could not be loaded.
        case internalServerError
    }

    public static let responseCases: ResponseMap = [
        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound)),
        .code(500, .error(AudiobookshelfError.internalServerError))
    ]

}

public extension UpdatePodcastEpisode.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {
        let title: String?
        let subtitle: String?
        let description: String?
        let enclosure: EnclosureUpdate?
        let pubDate: String?
        let season: String?
        let episode: String?
        let episodeType: String?
        let publishedAt: Int?
    }

    /// A change to an episode's enclosure.
    ///
    /// The server only accepts an enclosure object when it carries a `url`, and treats an explicit
    /// `null` as a request to clear the URL, type and size together. There is no way to change one
    /// enclosure field in isolation.
    enum EnclosureUpdate: Encodable, Sendable {

        /// Replace the enclosure. Fields left nil are stored as null.
        case set(EnclosurePayload)

        /// Remove the enclosure entirely.
        case clear

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .set(let payload):
                try container.encode(payload)

            case .clear:
                try container.encodeNil()
            }
        }

    }

    struct EnclosurePayload: Encodable, Sendable {

        /// The URL the episode audio can be downloaded from. Required by the server.
        let url: String

        /// The MIME type of the episode audio.
        let type: String?

        /// The size (in bytes) of the episode audio, sent as a string.
        let length: String?

        public init(
            url: String,
            type: String? = nil,
            length: String? = nil
        ) {
            self.url = url
            self.type = type
            self.length = length
        }
    }

}
