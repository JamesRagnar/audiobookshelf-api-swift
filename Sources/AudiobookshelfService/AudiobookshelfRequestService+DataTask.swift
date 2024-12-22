//
//  AudiobookshelfRequestService+DataTask.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-19.
//

import AudiobookshelfInterface
import Foundation
import OSLog

public extension AudiobookshelfRequestService {
    
    func dataTask<T: Interface>(
        _ interface: T.Type,
        _ parameters: T.Parameters
    ) async throws -> T.Response {
        var interfaceRequest: URLRequest!
        do {
            interfaceRequest = try request(interface, parameters)
        } catch {
            throw error
        }
        
        do {
            return try T.handle(
                try await dataTaskProvider.data(for: interfaceRequest)
            )
        } catch {
            throw error
        }
    }
    
    func request<T: Interface>(
        _ interface: T.Type,
        _ parameters: T.Parameters
    ) throws -> URLRequest {
        return try URLRequest(
            requestParameters: parameters,
            serverConfiguration: try getConfiguration()
        )
    }

}

public extension AudiobookshelfRequestService {
    
    static func dataTask<T: Interface>(
        _ interface: T.Type,
        _ parameters: T.Parameters,
        _ configuration: ServerConfiguration,
        _ dataTaskProvider: DataTaskProvider
    ) async throws -> T.Response {
        let request = try URLRequest(
            requestParameters: parameters,
            serverConfiguration: configuration
        )
        
        return try T.handle(
            try await dataTaskProvider.data(for: request)
        )
    }

}
