# Audiobookshelf API Swift
A Swift Package providing Model, Interface, and Socket support for Audiobookshelf servers. 

[Audiobookshelf](https://www.audiobookshelf.org/)

[Docs](https://api.audiobookshelf.org/#introduction)

> [!NOTE]
> Work in progress, current status of each Module:
> 
> | ✔️ | Models |
> |---------------|:----------------------------------------|
>
> | ⚠️ | Interfaces |
> |---------------|:----------------------------------------|
>
> | ✔️ | Sockets |
> |---------------|:----------------------------------------|

## Components

### Models

```swift
public struct Collection {
    
    /// The ID of the collection.
    public let id: String
    
    /// The ID of the library the collection belongs to.
    public let libraryId: String
    
    /// The ID of the user that created the collection.
    public let userId: String?
    
    /// The name of the collection.
    public let name: String
    
    /// The collection's description. Will be null if there is none.
    public let description: String?
    
    /// The books that belong to the collection.
    /// - Note: Collection Expanded - books is array of Library Item Expanded
    public let books: [LibraryItem]
    
    /// The time (in ms since POSIX epoch) when the collection was last updated.
    public let lastUpdate: Int
    
    /// The time (in ms since POSIX epoch) when the collection was created.
    public let createdAt: Int
    
    // MARK: Collection + rssfeed
    
    /// The collection's currently open RSS feed. Will be null if the collection does not have an open RSS feed.
    /// - Note: Collection rssfeed - Added Attribute
    public let rssFeed: RSSFeed?
    
}

extension Collection: Decodable {}
extension Collection: Sendable {}

```
### Interfaces

```swift
public protocol Interface: Sendable {

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
/// This endpoint matches all items in a library using quick match.
/// Quick match populates empty book details and the cover with the first book result from the library's default metadata provider.
/// Does not overwrite details unless the "Prefer matched metadata" server setting is enabled.
public struct MatchAllLibraryItems: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Match All Library Items
        ///
        /// - Parameter libraryID: The ID of the library.
        public init(libraryID: String) {
            self.path = "/api/libraries/\(libraryID)/matchall"
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = String
    
    public enum AudiobookshelfError: Error {
        
        case forbidden
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// An admin user is required to match library items.
        403: .failure(AudiobookshelfError.forbidden),
        
        /// The user cannot access the library, or no library with the provided ID exists.
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}
```

### Sockets

```swift
public protocol SocketEvent: Sendable {
    
    static var name: String { get }
    
    associatedtype Schema: Decodable
    
}
```

#### Examples

```swift
/// A library item was updated.
public struct ItemUpdatedEvent: SocketEvent {
    
    public static let name = "item_updated"
    
    public typealias Schema = LibraryItem

}
```

### Services

#### Request Service

Providing endpoint and credential management.

```swift
import AudiobookshelfAPI

class DemoClass {

    let serverURL = #url
    let authToken = #token

    var myRequestService = AudiobookshelfRequestService(dataTaskProvider: URLSession.shared)
    myRequestService.configurationProvider = self

}

extension DemoClass: ServerConfigurationProvider {

    var serverConfiguration: ServerConfiguration? {
        .init(
            url: serverURL,
            authToken: token
        )
    }

}
```

Making requests

```swift
let author = try await myRequestService.dataTask(
    GetAuthor.self,
    .init(
        authorID: authorID,
        include: [.items, .series],
        libraryID: libraryID
    )
)
```

#### Socket Service

##### Creating and connecting socket

```swift
import AudiobookshelfAPI

var mySocketService = AudiobookshelfSocketService(url: #url)
```

##### Emitting User Events

```swift
mySocketService.sendEvent(AuthEvent.self, #token)
```

##### Observing server events

```swift
var cancellables = Set<AnyCancellable>()

mySocketService
    .observeEvent(
        UserItemProgressUpdated.self
    )
    .sink { itemProgress in
        print("Item Progress Did Update")
    }
    .store(in: cancellables)
```
