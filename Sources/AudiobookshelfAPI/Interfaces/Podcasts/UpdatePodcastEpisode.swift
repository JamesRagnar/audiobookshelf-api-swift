//
//  UpdatePodcastEpisode.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update podcast episode metadata.
public struct UpdatePodcastEpisode: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Update Podcast Episode Parameters
        ///
        /// - Parameters:
        ///   - podcastId: The ID of the podcast library item.
        ///   - episodeId: The ID of the episode.
        ///   - title: Episode title (optional).
        ///   - subtitle: Episode subtitle (optional).
        ///   - description: Episode description (optional).
        ///   - enclosure: Episode enclosure data (optional).
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
            enclosure: EnclosurePayload? = nil,
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

    public typealias Response = PodcastEpisode

    public enum AudiobookshelfError: Error {
        case badRequest
        case forbidden
        case notFound
    }

    public static let responseCases: ResponseCases = [
        200: .success(Response.self),
        400: .failure(AudiobookshelfError.badRequest),
        403: .failure(AudiobookshelfError.forbidden),
        404: .failure(AudiobookshelfError.notFound)
    ]

}

public extension UpdatePodcastEpisode.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {
        let title: String?
        let subtitle: String?
        let description: String?
        let enclosure: EnclosurePayload?
        let pubDate: String?
        let season: String?
        let episode: String?
        let episodeType: String?
        let publishedAt: Int?
    }

    struct EnclosurePayload: Encodable, Sendable {
        let url: String?
        let type: String?
        let length: String?

        public init(
            url: String? = nil,
            type: String? = nil,
            length: String? = nil
        ) {
            self.url = url
            self.type = type
            self.length = length
        }
    }

}
