//
//  EReaderDevice.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation

public struct EReaderDevice {

    /// The name of the eReader device.
    public let name: String

    /// The email associated with the eReader device.
    public let email: String

    /// The availability status of the device.
    public let availabilityStatus: String?

}

extension EReaderDevice: Codable {}
extension EReaderDevice: Sendable {}
