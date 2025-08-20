//
//  Backup.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct Backup {
    
    /// The ID of the backup. Will be the date and time when the backup was created.
    public let id: String
    
    /// Whether the backup includes library item covers and author images located in metadata.
    public let backupMetadataCovers: Bool
    
    /// The backup directory path.
    public let backupDirPath: String
    
    /// The date and time when the backup was created in a human-readable format.
    public let datePretty: String
    
    /// The full path of the backup on the server.
    public let fullPath: String
    
    /// The path of the backup relative to the metadata directory.
    public let path: String
    
    /// The filename of the backup.
    public let filename: String
    
    /// The size (in bytes) of the backup file.
    public let fileSize: Int
    
    /// The time (in ms since POSIX epoch) when the backup was created.
    public let createdAt: Int
    
    /// The version of the server when the backup was created.
    public let serverVersion: String
    
}

extension Backup: Decodable {}
extension Backup: Sendable {}
