# Sockets

## Summary

An overview of Socket structure, components, and exceptions.

## Overview

The Socket protocol is defined in RagnarNetworking, and provides a structure of defining the event name and expected response type.

```swift
// Provide a comment describing the event and expected actions.
public protocol SocketEvent: Sendable {
    
	// The event name to observe
    static var name: String { get }
    
    // The expected response type
    associatedtype Schema: Decodable
    
}
```

## Common Patterns

### Shared Response Models

Socket events will generally emit an update to a notification, referencing a shared Model. This can be associated inline by using a typealias.

```swift
public struct ExampleEvent: SocketEvent {
    
    public static let name = "example_event"
    
    public typealias Schema = SharedModel

}
```

### Custom Response Models

In the event the Socket fires a one-off or modified event, the shared Model should not be updated. Instead, a local reference can be defined in an extension to the Event struct. The extension, struct, and parameters must be marked as public.

```swift
public struct ExampleEvent: SocketEvent {
    
    public static let name = "example_event"
    
    public typealias Schema = CustomResponse

}

public extension ExampleEvent {

	public struct CustomResponse: Decodable {

		public let parameter: String

	}

}
```

## Design Considerations

- Ensure SocketEvents and components are marked as public.
- Comments should be minimal and dedicated to explaining API operations. Avoid example code blocks or superfluous descriptions, the models should be clear and explicit.

## Validation Checklist

Before submitting a SocketEvent implementation, verify:

- [ ] All types marked `public` (struct, enum)
- [ ] Event struct conforms to SocketEvent protocol
- [ ] Static `name` property defined with correct event name
- [ ] Schema typealias defined (pointing to Model or custom Response)
- [ ] Custom Response in extension if needed (not inline)
- [ ] All custom Response properties marked `public let`
- [ ] Custom Response conforms to Decodable
- [ ] Top-level comment describes socket event operation
- [ ] File header includes proper copyright and creation info
- [ ] Imports Foundation and RagnarNetworking

## Common Mistakes

### WRONG: Missing public modifier on event

```swift
struct ExampleEvent: SocketEvent {  // Missing public
    static let name = "example_event"
    typealias Schema = SharedModel
}
```

### CORRECT: Public event struct

```swift
public struct ExampleEvent: SocketEvent {
    public static let name = "example_event"
    public typealias Schema = SharedModel
}
```

### WRONG: Custom response inline

```swift
public struct ExampleEvent: SocketEvent {
    public static let name = "example_event"

    public struct CustomResponse: Decodable {  // DON'T DO THIS
        public let id: String
    }

    public typealias Schema = CustomResponse
}
```

### CORRECT: Custom response in extension

```swift
public struct ExampleEvent: SocketEvent {
    public static let name = "example_event"
    public typealias Schema = CustomResponse
}

public extension ExampleEvent {
    struct CustomResponse: Decodable {  // DO THIS
        public let id: String
    }
}
```

### WRONG: Missing public on custom response properties

```swift
public extension ExampleEvent {
    struct CustomResponse: Decodable {
        let id: String  // Missing public
    }
}
```

### CORRECT: All properties public

```swift
public extension ExampleEvent {
    struct CustomResponse: Decodable {
        public let id: String
    }
}
```

### WRONG: Missing static on name property

```swift
public struct ExampleEvent: SocketEvent {
    public let name = "example_event"  // Should be static
    public typealias Schema = SharedModel
}
```

### CORRECT: Static name property

```swift
public struct ExampleEvent: SocketEvent {
    public static let name = "example_event"
    public typealias Schema = SharedModel
}
```
