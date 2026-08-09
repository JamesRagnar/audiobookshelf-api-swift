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

    /// The access policy for the device.
    public let availabilityOption: String?

    /// The users allowed to access the device.
    public let users: [String]?

    public init(
        name: String,
        email: String,
        availabilityOption: String? = nil,
        users: [String]? = nil
    ) {
        self.name = name
        self.email = email
        self.availabilityOption = availabilityOption
        self.users = users
    }

}

extension EReaderDevice: Codable {}
extension EReaderDevice: Sendable {}
