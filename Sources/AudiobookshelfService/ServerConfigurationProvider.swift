//
//  ServerConfigurationProvider.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import AudiobookshelfInterface
import Foundation

public protocol ServerConfigurationProvider: AnyObject {
    
    var serverConfiguration: ServerConfiguration? { get }
    
}
