//
//  SocketService.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-10.
//

import AudiobookshelfSocket
import Combine
import Foundation
import SocketIO

open class AudiobookshelfSocketService {
    
    public enum SocketStatus: Int {
        
        /// The client/manager has never been connected. Or the client has been reset.
        case notConnected
        
        /// The client/manager was once connected, but not anymore.
        case disconnected
        
        /// The client/manager is in the process of connecting.
        case connecting
        
        /// The client/manager is currently connected.
        case connected
     
    }
    
    public func sendEvent<Event: SocketEvent>(
        _ socketEvent: Event.Type,
        _ message: Event.Schema
    ) {
        guard let message = message as? SocketData else {
            return
        }
        
        manager
            .defaultSocket
            .emit(
                socketEvent.name,
                message
            )
    }
    
    public func observeEvent<Event: SocketEvent>(
        _ socketEvent: Event.Type
    ) -> AnyPublisher<Event.Schema, Never> {
        return eventPublisher
            .filter { $0.event == socketEvent.name }
            .compactMap { event -> Event.Schema? in
                guard let item = event.items?.first else { return nil }
                
                // Raw types
                if let item = item as? Event.Schema {
                    return item
                }
                
                // Decodable
                if
                    let item = item as? [String: Any],
                    let jsonData = try? JSONSerialization.data(
                        withJSONObject: item,
                        options: []
                    ),
                    let body = try? JSONDecoder().decode(
                        Event.Schema.self,
                        from: jsonData
                    )
                {
                    return body
                }
                
                return nil
            }
            .eraseToAnyPublisher()
    }
    
    private var eventSubject = PassthroughSubject<SocketAnyEvent, Never>()
    
    public var eventPublisher: AnyPublisher<SocketAnyEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    private var statusSubject = CurrentValueSubject<SocketStatus, Never>(.notConnected)
    
    public var statusPublisher: AnyPublisher<SocketStatus, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    
    private var manager: SocketManager
    
    public var socketID: String? {
        manager.defaultSocket.sid
    }
    
    public init(
        url: URL
    ) {
        manager = SocketManager(
            socketURL: url,
            config: []
        )
        
        manager
            .defaultSocket
            .onAny { [weak self] event in
                self?.eventSubject.send(event)
            }
        
        manager
            .defaultSocket
            .on(clientEvent: .statusChange) { [weak self] (status, _) in
                guard
                    let statusInt = status.last as? Int,
                    let status = SocketStatus(rawValue: statusInt)
                else { return }
                
                self?.statusSubject.send(status)
            }
        
        manager.defaultSocket.connect()
    }
    
    public func disconnect() {
        manager.disconnect()
    }

}
