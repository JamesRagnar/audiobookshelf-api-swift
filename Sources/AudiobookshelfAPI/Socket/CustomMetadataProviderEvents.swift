//
//  CustomMetadataProviderEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// A custom metadata provider was added.
public struct CustomMetadataProviderAddedEvent: SocketEvent {

    public static let name = "custom_metadata_provider_added"

    public typealias Schema = CustomMetadataProvider

}

/// A custom metadata provider was removed.
public struct CustomMetadataProviderRemovedEvent: SocketEvent {

    public static let name = "custom_metadata_provider_removed"

    public typealias Schema = String

}
