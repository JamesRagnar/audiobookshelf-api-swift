//
//  JSONValue.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-02-06.
//

import Foundation

public enum JSONValue: Decodable, Sendable {

    case object([String: JSONValue])
    case array([JSONValue])
    case string(String)
    case number(Double)
    case bool(Bool)
    case null

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            var object: [String: JSONValue] = [:]
            for key in container.allKeys {
                object[key.stringValue] = try container.decode(JSONValue.self, forKey: key)
            }
            self = .object(object)
            return
        }

        if var container = try? decoder.unkeyedContainer() {
            var values: [JSONValue] = []
            while !container.isAtEnd {
                values.append(try container.decode(JSONValue.self))
            }
            self = .array(values)
            return
        }

        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON value")
        }
    }

    private enum CodingKeys: CodingKey {
        case dynamic(String)

        init?(stringValue: String) {
            self = .dynamic(stringValue)
        }

        var stringValue: String {
            switch self {
            case .dynamic(let value):
                return value
            }
        }

        init?(intValue: Int) {
            return nil
        }

        var intValue: Int? {
            return nil
        }
    }

}
