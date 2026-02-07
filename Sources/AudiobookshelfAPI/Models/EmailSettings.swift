//
//  EmailSettings.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-02-06.
//

import Foundation

public struct EmailSettings: Decodable, Sendable {

    public let host: String?

    public let port: Int?

    public let secure: Bool?

    public let user: String?

    public let pass: String?

    public let fromAddress: String?

    public let testAddress: String?

}
