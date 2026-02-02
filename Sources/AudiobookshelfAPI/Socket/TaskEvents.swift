//
//  TaskEvents.swift
//  AudiobookshelfAPI
//
//  Created by Claude on 2026-01-29.
//

import Foundation
import RagnarNetworking

/// Background task started notification.
public struct TaskStarted: SocketInboundEvent {

    public static let name = "task_started"

    public typealias Payload = BackgroundTask

}

/// Background task finished notification.
public struct TaskFinished: SocketInboundEvent {

    public static let name = "task_finished"

    public typealias Payload = BackgroundTask

}

/// Background task progress update notification (admin only).
public struct TaskProgress: SocketInboundEvent {

    public static let name = "task_progress"

    public typealias Payload = CustomResponse

}

public extension TaskProgress {

    struct CustomResponse: Decodable, Sendable {

        /// The task being updated.
        public let task: BackgroundTask

        /// Progress description message.
        public let description: String?

    }

}
