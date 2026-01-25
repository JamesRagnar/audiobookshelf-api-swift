//
//  EReaderEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// The list of eReader devices was updated.
public struct EReaderDevicesUpdatedEvent: SocketEvent {

    public static let name = "ereader-devices-updated"

    public typealias Schema = [EReaderDevice]

}
