# Models

## Summary

The Model structure defines the shared API data definitions, shared between response and socket events. Models may contain minified or expanded data fields, based on the response types.

## Overview

Models are simple Swift structs, with the bare minimum components required to fulfill the model definition. Models must conform to Decodable and Sendable. 

```swift
public struct ResponseModel {
	
	public let parameter: String

}

extension ResponseModel: Decodable {}
extension ResponseModel: Sendable {}
```

Parameters follow Swift naming patterns, with types and optionality derived from the response schema. In the event of a mismatch, CodingKeys map server name values to the Swift versions. 

## Common Patterns

### Coding Keys

In the event that a server definition does not match Swift naming conventions, CodingKeys should be used to map the server value to the Model definition. These keys are defined in an extension to the Model, and are not marked as public. This extension can include the Decodable conformance, as this logic is directly related.

```swift
public struct ResponseModel {
	
	public let parameterName: String

}

extension ResponseModel: Decodable {
	
	enum CodingKeys: String, CodingKey {

		case parameterName = "parameter_name"

	}

}
```

### Complex Decoding

In the event that the server defines complex model definitions, with multiple types or cases, it may be necessary to include dedicated decoding logic to map the response value over to the expected Model type.

```swift
public struct ResponseModel {
	
	public let parameterName: String

}

extension ResponseModel: Decodable {
	
	enum CodingKeys: String, CodingKey {

		case parameterName = "parameter_name"

	}

	public init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		// parameter may be a Bool or String with "true" or "false" options
		if let boolValue = try container.decode(Bool.self, forKey: .parameterName) {
			self.parameterName = boolValue.description
		} else {
			self.parameterName = try container.decode(String.self, forKey: .parameterName)
		}
	}

}
```

## Design Considerations

- Ensure Model and components are marked as public.
- Comments should be designed to be self-documenting, providing clear data structure definitions. Do not include example usage code or superfluous comments, let the code define itself.
- Keep models simple - avoid computed properties or business logic.
- Use extensions for protocol conformances (Decodable, Sendable) to keep the main struct clean.

## Validation Checklist

Before submitting a Model implementation, verify:

- [ ] All types marked `public` (struct, enum)
- [ ] All public properties marked `public let`
- [ ] Model conforms to Decodable & Sendable
- [ ] CodingKeys in extension if needed (not inline)
- [ ] Custom init(from:) in extension if needed
- [ ] Protocol conformances in extensions
- [ ] File header includes proper copyright and creation info
- [ ] Imports Foundation

## Common Mistakes

### WRONG: Missing public modifiers

```swift
struct ResponseModel {  // Missing public
    let id: String  // Missing public
}
```

### CORRECT: All public

```swift
public struct ResponseModel {
    public let id: String
}

extension ResponseModel: Decodable {}
extension ResponseModel: Sendable {}
```

### WRONG: CodingKeys inline

```swift
public struct ResponseModel: Decodable {
    public let userName: String

    enum CodingKeys: String, CodingKey {  // DON'T DO THIS
        case userName = "user_name"
    }
}
```

### CORRECT: CodingKeys in extension

```swift
public struct ResponseModel {
    public let userName: String
}

extension ResponseModel: Decodable {
    enum CodingKeys: String, CodingKey {  // DO THIS
        case userName = "user_name"
    }
}

extension ResponseModel: Sendable {}
```

### WRONG: Protocol conformances inline

```swift
public struct ResponseModel: Decodable, Sendable {  // DON'T DO THIS
    public let id: String
}
```

### CORRECT: Protocol conformances in extensions

```swift
public struct ResponseModel {
    public let id: String
}

extension ResponseModel: Decodable {}
extension ResponseModel: Sendable {}
```
