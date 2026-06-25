//
//  LibraryItemEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// A library item was created.
public struct ItemAddedEvent: SocketEvent {

    public static let name = "item_added"

    public typealias Schema = LibraryItem

}

/// A library item was updated.
public struct ItemUpdatedEvent: SocketEvent {

    public static let name = "item_updated"

    public typealias Schema = LibraryItem

}

/// A library item was deleted.
public struct ItemRemovedEvent: SocketEvent {

    public static let name = "item_removed"

    public typealias Schema = ItemRemovedPayload

}

extension ItemRemovedEvent {

    public struct ItemRemovedPayload: Decodable, Sendable {

        /// The ID of the removed library item.
        public let id: String

        /// The IDs of removed library items.
        /// On current servers this is always `[id]`. On legacy servers that sent a
        /// `libraryItemIds` array instead of a singular `id`, this reflects that array.
        public let libraryItemIds: [String]

        /// The ID of the library.
        /// - Note: Present on server `>= 2.33.2`.
        public let libraryId: String?

        private enum CodingKeys: String, CodingKey {
            case id
            case libraryItemIds
            case libraryId
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            if let id = try container.decodeIfPresent(String.self, forKey: .id) {
                self.id = id
                self.libraryItemIds = [id]
            } else if let ids = try container.decodeIfPresent([String].self, forKey: .libraryItemIds),
                      let first = ids.first {
                self.id = first
                self.libraryItemIds = ids
            } else {
                throw DecodingError.keyNotFound(
                    CodingKeys.id,
                    .init(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected either 'id' or non-empty 'libraryItemIds' for item_removed payload."
                    )
                )
            }

            self.libraryId = try container.decodeIfPresent(String.self, forKey: .libraryId)
        }

    }

}

/// Library items were created.
public struct ItemsAddedEvent: SocketEvent {

    public static let name = "items_added"

    public typealias Schema = [LibraryItem]

}

/// Library items were updated.
public struct ItemsUpdatedEvent: SocketEvent {

    public static let name = "items_updated"

    public typealias Schema = [LibraryItem]

}

/// Batch library item quick matching is complete.
public struct BatchQuickMatchCompleteEvent: SocketEvent {

    public static let name = "batch_quickmatch_complete"

    public typealias Schema = BatchQuickMatchResult

}

extension BatchQuickMatchCompleteEvent {

    public struct BatchQuickMatchResult: Decodable, Sendable {

        /// Whether library items were successfully updated.
        public let success: Bool

        /// The number of library items that were updated.
        public let updates: Int

        /// The number of library items that a match could not be found for.
        public let unmatched: Int

    }

}
