//
//  File.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation

/// A backup was applied to the server.
public struct BackupAppliedEvent: SocketEvent {
    
    public static let name = "backup_applied"
    
    public typealias Schema = EmptyBody

}
