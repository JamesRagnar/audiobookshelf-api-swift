//
//  DeviceInfo.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct DeviceInfo {
    
    /// Unique identifier.
    public let id: UUID
    
    /// User identifier.
    public let userId: UUID
    
    /// Device identifier, as provided in the request.
    public let deviceId: String
    
    /// The IP address that the request came from.
    public let ipAddress: String?
    
    /// The browser name, taken from the user agent.
    public let browserName: String?
    
    /// The browser version, taken from the user agent.
    public let browserVersion: String?
    
    /// The name of OS, taken from the user agent.
    public let osName: String?
    
    /// The version of the OS, taken from the user agent.
    public let osVersion: String?
    
    /// The device name, constructed automatically from other attributes.
    public let deviceName: String?
    
    /// The device type, taken from the user agent.
    public let deviceType: String?
    
    /// The client device's manufacturer, as provided in the request.
    public let manufacturer: String?
    
    /// The client device's model, as provided in the request.
    public let model: String?
    
    /// For an Android device, the Android SDK version of the client, as provided in the request.
    public let sdkVersion: Int?
    
    /// Name of the client, as provided in the request.
    public let clientName: String
    
    /// Version of the client, as provided in the request.
    public let clientVersion: String
    
}

extension DeviceInfo: Decodable {}
extension DeviceInfo: Sendable {}
