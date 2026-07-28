//
//  AuthSessionDeviceInfo.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-07-27.
//

import Foundation

/// Device details the server parsed out of an auth session's user agent string.
///
/// Every field is omitted by the server when it could not be determined, and the whole object is null
/// when nothing at all could be parsed. This is a display convenience only.
///
/// - Note: This is distinct from `DeviceInfo`, which describes the device attached to a
///   `PlaybackSession` and is built from values the client reports explicitly.
/// - Note: Requires server `>= 2.36.0`.
public struct AuthSessionDeviceInfo {

    /// The browser name, taken from the user agent.
    public let browserName: String?

    /// The browser version, taken from the user agent.
    public let browserVersion: String?

    /// The name of the OS, taken from the user agent.
    public let osName: String?

    /// The version of the OS, taken from the user agent.
    public let osVersion: String?

    /// The device type, taken from the user agent.
    public let deviceType: String?

    /// The device model, taken from the user agent.
    public let model: String?

    /// The device vendor, taken from the user agent.
    public let vendor: String?

}

extension AuthSessionDeviceInfo: Decodable {}
extension AuthSessionDeviceInfo: Sendable {}
