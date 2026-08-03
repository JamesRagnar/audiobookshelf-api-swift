//
//  TaskEvents.swift
//  AudiobookshelfAPI
//
//  Created by Claude on 2026-01-29.
//

import Foundation
import RagnarSocketIO

/// Background task started notification.
public struct TaskStarted: SocketEvent {

    public static let name = "task_started"

    public typealias Schema = BackgroundTask

}

/// Background task finished notification.
public struct TaskFinished: SocketEvent {

    public static let name = "task_finished"

    public typealias Schema = BackgroundTask

}

/// Progress update for a long-running library item task. (Admin Only)
///
/// Emitted by the metadata embed and M4B merge tools. Unlike ``TaskStarted`` and ``TaskFinished``
/// this does not carry a ``BackgroundTask``; correlate it to a running task by `libraryItemId`.
public struct TaskProgress: SocketEvent {

    public static let name = "task_progress"

    public typealias Schema = CustomResponse

}

public extension TaskProgress {

    struct CustomResponse: Decodable, Sendable {

        /// The ID of the library item the task is working on.
        public let libraryItemId: String

        /// Overall progress percentage (0-100) across the whole task.
        public let progress: Float

    }

}
