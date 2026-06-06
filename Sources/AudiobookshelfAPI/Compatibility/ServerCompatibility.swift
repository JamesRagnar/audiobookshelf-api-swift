//
//  ServerCompatibility.swift
//  AudiobookshelfAPI
//

/// The result of evaluating a server version string against the package's known-compatible range.
public enum CompatibilityResult: Sendable, Equatable {

    /// The server version is within the supported range.
    case supported

    /// The server version is below the minimum supported version.
    case belowMinimum

    /// The server version is above the highest tested minor version line.
    case aboveTestedRange

    /// The version string could not be parsed into a recognizable semver format.
    case unknownVersionFormat

}

/// Evaluates audiobookshelf server version strings against the package's known-compatible range.
///
/// Compatibility is evaluated at the `MAJOR.MINOR` level. Patch releases are assumed
/// non-breaking per semver convention and are not used to gate compatibility.
///
/// - Minimum supported minor: **2.26**
/// - Maximum tested minor: **2.35**
public enum ServerCompatibility: Sendable {

    private static let minimumVersion = Version(major: 2, minor: 26, patch: 0)
    private static let maximumTestedVersion = Version(major: 2, minor: 35, patch: .max)

    /// Evaluates whether `serverVersion` falls within the supported range.
    public static func evaluate(serverVersion: String) -> CompatibilityResult {
        guard let version = Version(parsing: serverVersion) else {
            return .unknownVersionFormat
        }
        if version < minimumVersion {
            return .belowMinimum
        }
        if version > maximumTestedVersion {
            return .aboveTestedRange
        }
        return .supported
    }

    /// Returns `true` only when `evaluate` returns `.supported`.
    public static func isSupported(serverVersion: String) -> Bool {
        evaluate(serverVersion: serverVersion) == .supported
    }

}

// MARK: - Version

private struct Version: Comparable {

    let major: Int
    let minor: Int
    let patch: Int

    init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    /// Parses a version string of the form `MAJOR.MINOR.PATCH`.
    init?(parsing raw: String) {
        let parts = raw.split(separator: ".", omittingEmptySubsequences: false)
        guard parts.count == 3,
              let major = Int(parts[0]),
              let minor = Int(parts[1]),
              let patch = Int(parts[2]) else {
            return nil
        }
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }

}
