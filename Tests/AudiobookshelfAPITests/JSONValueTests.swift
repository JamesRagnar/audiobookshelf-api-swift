import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct JSONValueTests {

    // MARK: Scalar cases

    @Test
    func decodesString() throws {
        let value = try decode("\"hello\"")
        guard case .string(let str) = value else {
            Issue.record("Expected .string, got \(value)")
            return
        }
        #expect(str == "hello")
    }

    @Test
    func decodesNumber() throws {
        let value = try decode("3.14")
        guard case .number(let num) = value else {
            Issue.record("Expected .number, got \(value)")
            return
        }
        #expect(num == 3.14)
    }

    @Test
    func decodesInteger() throws {
        let value = try decode("42")
        guard case .number(let num) = value else {
            Issue.record("Expected .number, got \(value)")
            return
        }
        #expect(num == 42)
    }

    @Test
    func decodesBoolTrue() throws {
        let value = try decode("true")
        guard case .bool(let flag) = value else {
            Issue.record("Expected .bool, got \(value)")
            return
        }
        #expect(flag == true)
    }

    @Test
    func decodesBoolFalse() throws {
        let value = try decode("false")
        guard case .bool(let flag) = value else {
            Issue.record("Expected .bool, got \(value)")
            return
        }
        #expect(flag == false)
    }

    @Test
    func decodesNull() throws {
        let json = "{\"key\": null}"
        let wrapper = try JSONDecoder().decode([String: JSONValue].self, from: Data(json.utf8))
        guard case .null = wrapper["key"] else {
            Issue.record("Expected .null")
            return
        }
    }

    // MARK: Bool is decoded before Double (no false→0.0 coercion)

    @Test
    func trueDoesNotDecodeAsNumber() throws {
        let value = try decode("true")
        if case .number = value {
            Issue.record("true must not decode as .number")
        }
    }

    // MARK: Collection cases

    @Test
    func decodesArray() throws {
        let value = try decode("[1, \"two\", true]")
        guard case .array(let elements) = value else {
            Issue.record("Expected .array, got \(value)")
            return
        }
        #expect(elements.count == 3)
        guard case .number(let num) = elements[0] else { Issue.record("elements[0] should be .number"); return }
        #expect(num == 1)
        guard case .string(let str) = elements[1] else { Issue.record("elements[1] should be .string"); return }
        #expect(str == "two")
        guard case .bool(let flag) = elements[2] else { Issue.record("elements[2] should be .bool"); return }
        #expect(flag == true)
    }

    @Test
    func decodesObject() throws {
        let value = try decode("{\"name\": \"James\", \"count\": 7}")
        guard case .object(let dict) = value else {
            Issue.record("Expected .object, got \(value)")
            return
        }
        guard case .string(let name) = dict["name"] else { Issue.record("name should be .string"); return }
        #expect(name == "James")
        guard case .number(let count) = dict["count"] else { Issue.record("count should be .number"); return }
        #expect(count == 7)
    }

    // MARK: Nested structures

    @Test
    func decodesNestedObjectAndArray() throws {
        let json = """
        {
          "items": [{"id": 1}, {"id": 2}],
          "meta": {"total": 2}
        }
        """
        let value = try decode(json)
        guard case .object(let root) = value else {
            Issue.record("Expected .object")
            return
        }
        guard case .array(let items) = root["items"] else {
            Issue.record("items should be .array")
            return
        }
        #expect(items.count == 2)
        guard case .object(let meta) = root["meta"],
              case .number(let total) = meta["total"] else {
            Issue.record("meta.total should be .number")
            return
        }
        #expect(total == 2)
    }

    // MARK: Helpers

    private func decode(_ json: String) throws -> JSONValue {
        try JSONDecoder().decode(JSONValue.self, from: Data(json.utf8))
    }

}
