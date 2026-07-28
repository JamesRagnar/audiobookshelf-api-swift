//
//  EReaderEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// The list of eReader devices was updated.
///
/// Broadcast to admins when the server-wide device list changes, and sent to an individual user when
/// their own accessible device list changes.
public struct EReaderDevicesUpdatedEvent: SocketEvent {

    public static let name = "ereader-devices-updated"

    public typealias Schema = Payload

}

extension EReaderDevicesUpdatedEvent {

    public struct Payload: Decodable, Sendable {

        /// The updated eReader devices.
        public let ereaderDevices: [EReaderDevice]

    }

}
