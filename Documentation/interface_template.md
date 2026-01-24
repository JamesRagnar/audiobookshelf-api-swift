# Interface Template

## Summary

An overview of Interface structure, compoenents, and exceptions.

## Overview

```swift
// Include a comment defining the operation performed by the request
// i.e. Updates the service to do an action, returning the result
public struct MyInterface: Interface {
    
    // MARK: Request

    // The request parameters. Does not need a comment.
    public struct Parameters: RequestParameters {

    	// RequestParameters should be set based on the request structure, in-line if possible
        public let method: RequestMethod = .get

		// If a paramater requries a dynamic input value, include it in the init below
        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        // Ensure the authentication structure is defined based on the server auth format.
        // These keys are automatically applied during the request process,
        // and are not included in the Parameters initialization.
        public let authentication: AuthenticationType = .bearer

        // Request requirements are defined here, often header, path, or body components
        public init(
        	someID: String
        ) {
        	self.path = "/api/\(someID)"
        }
        
    }
    
    // MARK: Response
    
    // The expected response body. Can also be a typealias to a shared Model.
    public struct Response: Decodable, Sendable {
        
        let parameter: String

    }
    
    // Predefined error scenerios, automatically mapped from server responses during decoding. 
    // Define any known cases where the server may define an error. Cases not covered here
    // will be captured by a generic error during the response processing
    public enum AudiobookshelfError: Error {
        
        case notFound
        
    }

    // The expected response cases, whith the known body or error types.
    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}
```

## Common Patterns

### Request Body

When a complex body type is required for a request, scope it to only be included in the Interface space. Avoid exposing Request body models where possible, lean on public parameter initialization and creating the request body locally

```swift
public struct MyInterface: Interface {
    
    public struct Parameters: RequestParameters {

    	// ...

    	public let body: Data?

    	init(
    		parameterOne: String,
    		parameterTwo: Int?
    	) {
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

## Response Body

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

Responses may also be a raw response type, one of String, Data

## Design Condierations

- Ensure Interface and components are marked as public.
- Comments should be designed to be self-documenting, providing clear operation scope and responsiblity. Do not include example request code or superflous comments, let the code define itself.
- Response 