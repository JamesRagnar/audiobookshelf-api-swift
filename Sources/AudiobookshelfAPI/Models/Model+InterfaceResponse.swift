//
//  Model+InterfaceResponse.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-08-03.
//

import Foundation
import RagnarNetworking

// `Interface.Response` requires `InterfaceResponse`. Every model below is `Decodable`, so it
// picks up the protocol's default JSON decoding without implementing anything.
//
// The conformances live here rather than on each declaration so the model layer keeps its
// `Foundation`-only imports. A model used as a response should not have to know that
// RagnarNetworking exists.

extension AudioBookmark: InterfaceResponse {}

extension Author: InterfaceResponse {}

extension BackupsResponse: InterfaceResponse {}

extension Collection: InterfaceResponse {}

extension JSONValue: InterfaceResponse {}

extension Library: InterfaceResponse {}

extension LibraryFilterData: InterfaceResponse {}

extension LibraryItem: InterfaceResponse {}

extension MediaProgress: InterfaceResponse {}

extension NotificationSettings: InterfaceResponse {}

extension PlaybackSession: InterfaceResponse {}

extension Playlist: InterfaceResponse {}

extension PodcastEpisode: InterfaceResponse {}

extension Series: InterfaceResponse {}

extension User: InterfaceResponse {}

extension YearStats: InterfaceResponse {}
