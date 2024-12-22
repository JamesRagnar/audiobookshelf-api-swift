//
//  LibraryScanEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation

/// A library scan was started.
public struct ScanStartEvent: SocketEvent {
    
    public static let name = "scan_start"
    
    public typealias Schema = LibraryScan

}

/// A library scan was completed.
public struct ScanCompleteEvent: SocketEvent {
    
    public static let name = "scan_complete"
    
    public typealias Schema = LibraryScan

}

public struct LibraryScan: Decodable {
    
    /// The ID of the scanned library.
    public let id: String
    
    /// The type of the library scan. Will be scan or match.
    public let type: String
    
    /// The name of the scanned library.
    public let name: String
    
    /// The results of the library scan. Will be null if the scan was canceled.
    public let results: LibraryScanResults?
        
}

public struct LibraryScanResults: Decodable {
    
    /// The number of library items added during the scan.
    public let added: Int
    
    /// The number of library items updated during the scan.
    public let updated: Int
    
    /// The number of library items discovered to be missing during the scan.
    public let missing: Int

}
