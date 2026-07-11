//
//  ArtworkFormat.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-07-10.
//

import Foundation

/// The requested image format for a scaled artwork request.
///
/// Shared between endpoints that return library item covers and author images.
public enum ArtworkFormat: String, Sendable {

    case webp

    case jpeg

}
