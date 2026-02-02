//
//  ShareEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// A share link was opened.
public struct ShareOpenEvent: SocketInboundEvent {

    public static let name = "share_open"

    public typealias Payload = Share

}

/// A share link was closed.
public struct ShareClosedEvent: SocketInboundEvent {

    public static let name = "share_closed"

    public typealias Payload = Share

}
