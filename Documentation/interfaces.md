# Interfaces

## Summary

An overview of Interface structure, components, and exceptions.

## Overview

The Interface protocol is defined in RagnarNetworking, and provides a structure of defining the requirements of a network request along with the expected response cases and types.

```swift
// Include a comment defining the operation performed by the request
// i.e. Updates the service to do an action, returning the result
public struct MyInterface: Interface {
    
    // MARK: Request

    // The request parameters. Does not need a comment.
    public struct Parameters: RequestParameters {

    	// RequestParameters should be set based on the request structure, in-line if possible
        public let method: RequestMethod = .get

		// If a parameter requires a dynamic input value, include it in the init below
        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        // Ensure the authentication structure is defined based on the server auth format.
        // These keys are automatically applied during the request process,
        // and are not included in the Parameters initialization.
        public let authentication: AuthenticationType = .bearer

        // Request requirements are defined here, often header, path, or body components.
        // Document each parameter type and call out exceptions or default values.
        public init(
        	someID: String
        ) {
        	self.path = "/api/\(someID)"
        }
        
    }
    
    // MARK: Response
    
    // The expected response body. Can also be a typealias to a shared Model.
    public struct Response: Decodable, Sendable {

        public let parameter: String

    }
    
    // Predefined error scenarios, automatically mapped from server responses during decoding. 
    // Define any known cases where the server may define an error. Cases not covered here
    // will be captured by a generic error during the response processing
    public enum AudiobookshelfError: Error {
        
        case notFound
        
    }

    // The expected response cases, with the known body or error types.
    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}
```

## Common Patterns

### Request Body

When a complex body type is required for a request, scope it to only be included in the Interface space. Avoid exposing Request body models where possible, lean on public parameter initialization and creating the request body locally. The Parameters init can throw, allowing the client to catch incorrect request structures.

```swift
public struct MyInterface: Interface {
    
    public struct Parameters: RequestParameters {

    	// ...

    	public let body: Data?

    	public init(
    		parameterOne: String,
    		parameterTwo: Int?
    	) throws {
    		self.body = try JSONEncoder()
    		.encode(
    			Body(
    				parameterOne: parameterOne,
    				parameterTwo: parameterTwo
    			)
    		)
    	}

    	// ...

    }

}

extension MyInterface.Parameters {
	
	struct Body: Encodable {

		let parameterOne: String

		let parameterTwo: Int?

	}

}
```

### Response Body

Generally, the Response type is a shared Model, which can be defined with a typealias

```swift
public struct MyInterface: Interface {
	
	// ...

	public typealias Response = SharedModel

	// ...

}
```

Some responses may use one-off models or containers for shared models. These types should be defined in an extension in a similar pattern to the Request Body, but must be marked as public. If the response body is a container that contains a known type, it should reference that model instead of recreating it. These models can be titled `Response`, which will automatically conform it to the Interface protocol.

```swift
public struct MyInterface: Interface {
	
	// ...

	// MARK: Response

    public static let responseCases: ResponseCases = [

        /// The requested narrators.
        200: .success(Response.self),

    ]

}

public extension MyInterface {
	
	public struct Response: Decodable, Sendable {

		public let responseID: String

		public let responseData: SharedModel

	}

}
```

Responses may also be a raw response type, one of String or Data.

## Design Considerations

- Ensure Interface and components are marked as public.
- Comments should be designed to be self-documenting, providing clear operation scope and responsibility. Do not include example request code or superfluous comments, let the code define itself.

## Validation Checklist

Before submitting an Interface implementation, verify:

- [ ] All types marked `public` (struct, enum, protocol)
- [ ] All public properties marked `public let`
- [ ] All inits marked `public init`
- [ ] Body struct in extension, not inline (if body is required)
- [ ] Init throws if encoding Body
- [ ] Response type is Decodable & Sendable
- [ ] AudiobookshelfError cases match API docs
- [ ] responseCases includes all documented status codes
- [ ] Top-level comment describes endpoint operation
- [ ] File header includes proper copyright and creation info
- [ ] Imports Foundation and RagnarNetworking

## Common Mistakes

### WRONG: Body struct inline

```swift
public struct Parameters: RequestParameters {
    struct Body: Encodable {  // DON'T DO THIS
        let id: String
    }

    public let body: Data?
}
```

### CORRECT: Body struct in extension

```swift
public struct Parameters: RequestParameters {
    public let body: Data?

    public init(id: String) throws {
        self.body = try JSONEncoder().encode(Body(id: id))
    }
}

extension MyInterface.Parameters {
    struct Body: Encodable {  // DO THIS
        let id: String
    }
}
```

### WRONG: Missing public modifiers

```swift
struct Response: Decodable, Sendable {  // Missing public
    let id: String  // Missing public
}
```

### CORRECT: All public

```swift
public struct Response: Decodable, Sendable {
    public let id: String
}
```

### WRONG: Missing throws on init with Body encoding

```swift
public init(name: String) {  // Should throw
    self.body = try JSONEncoder().encode(Body(name: name))  // Won't compile
}
```

### CORRECT: Init throws when encoding

```swift
public init(name: String) throws {
    self.body = try JSONEncoder().encode(Body(name: name))
}
```

### WRONG: Response struct in extension missing public

```swift
extension MyInterface {
    struct Response: Decodable, Sendable {  // Missing public on extension
        let id: String  // Missing public
    }
}
```

### CORRECT: Public extension and properties

```swift
public extension MyInterface {
    struct Response: Decodable, Sendable {
        public let id: String
    }
}
```
