//
//  ShareEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// A share link was opened.
public struct ShareOpenEvent: SocketEvent {

    public static let name = "share_open"

    public typealias Schema = Share

}

/// A share link was closed.
public struct ShareClosedEvent: SocketEvent {

    public static let name = "share_closed"

    public typealias Schema = Share

}
