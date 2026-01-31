//
//  BackgroundTask.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-29.
//

import Foundation

/// A long running background task.
public struct BackgroundTask {

    /// Unique task identifier.
    public let id: String

    /// Task type/action identifier.
    public let action: String

    /// Custom data for the action.
    public let data: [String: String]?

    /// Human-readable task title.
    public let title: String

    /// Translation key for title.
    public let titleKey: String

    /// Substitution values for title translation.
    public let titleSubs: [String]

    /// Detailed description of what the task is doing.
    public let description: String

    /// Translation key for description.
    public let descriptionKey: String

    /// Substitution values for description translation.
    public let descriptionSubs: [String]

    /// Error message if task failed.
    public let error: String?

    /// Translation key for error message.
    public let errorKey: String?

    /// Substitution values for error translation.
    public let errorSubs: [String]?

    /// Whether client should keep the task visible after success.
    public let showSuccess: Bool

    /// Whether task ended in failure.
    public let isFailed: Bool

    /// Whether task has completed.
    public let isFinished: Bool

    /// Timestamp when task started (in ms since POSIX epoch).
    public let startedAt: Int

    /// Timestamp when task completed (in ms since POSIX epoch).
    public let finishedAt: Int?

}

extension BackgroundTask: Decodable {}
extension BackgroundTask: Sendable {}
