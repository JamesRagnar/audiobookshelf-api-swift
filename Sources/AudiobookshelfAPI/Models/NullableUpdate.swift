/// A nullable write value, available throughout the maintained server range.
/// An optional property containing nil omits its wire key; `.null` sends JSON null.
public enum NullableUpdate<Value: Encodable & Sendable>: Encodable, Sendable {

    /// Sends the underlying value.
    case value(Value)

    /// Sends explicit JSON null; interpretation depends on the endpoint.
    case null

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .value(let value): try container.encode(value)
        case .null: try container.encodeNil()
        }
    }

}
