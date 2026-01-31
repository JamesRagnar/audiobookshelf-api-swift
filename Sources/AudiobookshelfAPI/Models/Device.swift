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

    /// Device identifier string
    public let deviceId: String

    /// User ID this device belongs to
    public let userId: String

    /// IP address of the device
    public let ipAddress: String

    /// Browser name (web clients only)
    public let browserName: String?

    /// Browser version (web clients only)
    /// - Note: Populated from deviceVersion for non-Android clients
    /// - Note: Will be null for Android clients (sdkVersion will be populated instead)
    public let browserVersion: String?

    /// Operating system name
    public let osName: String?

    /// Operating system version
    public let osVersion: String?

    /// Client version
    public let clientVersion: String?

    /// Device manufacturer
    public let manufacturer: String?

    /// Device model
    public let model: String?

    /// Android SDK version (Android clients only)
    /// - Note: Populated from deviceVersion for Android clients (when clientName == "Abs Android")
    /// - Note: Will be null for non-Android clients (browserVersion will be populated instead)
    public let sdkVersion: String?

    /// Device name (e.g., "Windows 10 Chrome", "Google Pixel 6")
    public let deviceName: String

    /// Client name (e.g., "Abs Web", "Abs Android")
    public let clientName: String

}

extension Device: Decodable {}
extension Device: Sendable {}
