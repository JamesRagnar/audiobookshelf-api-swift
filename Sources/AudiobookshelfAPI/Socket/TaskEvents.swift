//
//  TaskEvents.swift
//  AudiobookshelfAPI
//
//  Created by Claude on 2026-01-29.
//

import Foundation
import RagnarNetworking

/// Background task started notification.
public struct TaskStarted: SocketEvent {

    public static let name = "task_started"

    public typealias Schema = Task

}

/// Background task finished notification.
public struct TaskFinished: SocketEvent {

    public static let name = "task_finished"

    public typealias Schema = Task

}

/// Background task progress update notification (admin only).
public struct TaskProgress: SocketEvent {

    public static let name = "task_progress"

    public typealias Schema = CustomResponse

}

public extension TaskProgress {

    struct CustomResponse: Decodable, Sendable {

        /// The task being updated.
        public let task: Task

        /// Progress description message.
        public let description: String?

    }

}
