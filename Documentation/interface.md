# Interfaces

- defines the request, response, and models for each request

## Components

```swift
protocol Interface: Sendable {

    /// The parameters defining how to construct the network request
    associatedtype Parameters: RequestParameters

    /// The expected response type when the request succeeds
    associatedtype Response: Decodable, Sendable

    /// Maps HTTP status codes to their expected outcomes (success with a type, or a specific error)
    typealias ResponseCases = [Int: Result<Response.Type, Error>]

    /// Defines how each HTTP status code should be handled for this interface
    static var responseCases: ResponseCases { get }

}
```

```swift
protocol RequestParameters: Sendable {

    /// The HTTP method for this request (GET, POST, etc.)
    var method: RequestMethod { get }

    /// The path component of the URL (e.g., "/api/users/123")
    var path: String { get }

    /// Optional query parameters to append to the URL
    var queryItems: [String: String]? { get }

    /// Optional HTTP headers to include in the request
    var headers: [String: String]? { get }

    /// Optional request body data (typically JSON-encoded)
    var body: Data? { get }

    /// The authentication strategy for this request
    var authentication: AuthenticationType { get }

}
```

```swift
enum RequestMethod: String, Sendable {

    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case head = "HEAD"
    case delete = "DELETE"
    case patch = "PATCH"
    case options = "OPTIONS"
    case connect = "CONNECT"
    case trace = "TRACE"

}
```

```swift
enum AuthenticationType: Sendable {

    /// No authentication required for this request
    case none

    /// Authentication token included in request headers as `Authorization: Bearer <token>`
    case bearer

    /// Authentication token included in query parameters as `?token=<token>`
    case url

}
```

## Structure

