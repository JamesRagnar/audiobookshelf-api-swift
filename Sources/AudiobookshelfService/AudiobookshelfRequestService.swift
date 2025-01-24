//
//  AudiobookshelfRequestService+DataTask.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-19.
//

import AudiobookshelfInterface
import Foundation

public struct AudiobookshelfRequestService {
    
    public enum Error: Swift.Error {
        case badConfiguration
    }
    
    public weak var configurationProvider: ServerConfigurationProvider?
    
    public weak var loggingService: LoggingService?
    
    var dataTaskProvider: DataTaskProvider
    
    public init(dataTaskProvider: DataTaskProvider) {
        self.dataTaskProvider = dataTaskProvider
    }
    
    public func getConfiguration() throws -> ServerConfiguration {
        guard let configuration = configurationProvider?.serverConfiguration else {
            throw Error.badConfiguration
        }
        
        return configuration
    }
    
}
