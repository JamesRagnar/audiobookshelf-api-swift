//
//  Device.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation

/// Device database model for tracking user devices
public struct Device {

    /// Unique device identifier
    public let id: String

    /// User ID this device belongs to
    public let userId: String

    /// Device identifier string
    public let deviceId: String?

    /// Device name
    public let deviceName: String?

    /// Device type
    public let deviceType: String?

    /// Device version
    public let deviceVersion: String?

    /// Client name
    public let clientName: String?

    /// Client version
    public let clientVersion: String?

    /// Manufacturer name
    public let manufacturer: String?

    /// Model name
    public let model: String?

    /// SDK version
    public let sdkVersion: Int?

    /// Device creation timestamp
    public let createdAt: Int

    /// Device last update timestamp
    public let updatedAt: Int

}

extension Device: Decodable {}
extension Device: Sendable {}
