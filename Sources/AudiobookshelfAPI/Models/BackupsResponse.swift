//
//  BackupsResponse.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-02-06.
//

import Foundation

public struct BackupsResponse: Decodable, Sendable {

    public let backups: [Backup]

    public let backupLocation: String?

    public let backupPathEnvSet: Bool?

}
