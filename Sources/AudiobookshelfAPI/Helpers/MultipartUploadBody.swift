import Foundation

enum MultipartValidation {

    static func isNUL(_ scalar: Unicode.Scalar) -> Bool {
        scalar.value == 0
    }

    static func isNonEmptyText(_ value: String) -> Bool {
        !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !value.unicodeScalars.contains(where: isNUL)
    }

    static func isValidFilename(_ value: String) -> Bool {
        guard !value.isEmpty, value != ".", value != ".." else { return false }
        guard !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        return !value.unicodeScalars.contains { scalar in
            scalar == "/" || scalar == "\\" || scalar == "\"" ||
                scalar.value == 0 || scalar.value == 0x7F || scalar.value == 0x0D || scalar.value == 0x0A ||
                (0x01...0x1F).contains(scalar.value)
        }
    }

    static func isValidMIMEType(_ value: String) -> Bool {
        let parts = value.split(separator: "/", omittingEmptySubsequences: false)
        guard parts.count == 2 else { return false }
        let separators = "()<>@,;:\\\"/[]?={} \t"
        return parts.allSatisfy { part in
            !part.isEmpty && part.unicodeScalars.allSatisfy { scalar in
                scalar.value >= 0x21 && scalar.value <= 0x7E && !separators.unicodeScalars.contains(scalar)
            }
        }
    }

}

struct MultipartUploadBody: Sendable {

    enum ValidationError: Error {
        case boundaryGenerationFailed
    }

    let data: Data
    let contentType: String

    init(
        fileData: Data,
        filename: String,
        mimeType: String,
        boundaryGenerator: @escaping @Sendable () -> String,
        fields: [(String, String?)],
        partName: String = "file"
    ) throws(ValidationError) {
        for _ in 0..<8 {
            let boundary = boundaryGenerator()
            guard !boundary.isEmpty, boundary.utf8.allSatisfy({
                (48...57).contains($0) || (65...90).contains($0) || (97...122).contains($0) || $0 == 45
            }) else { continue }
            let header = "Content-Disposition: form-data; name=\"\(partName)\"; filename=\"\(filename)\"\r\n"
                + "Content-Type: \(mimeType)"
            let data = Self.makeData(
                boundary: boundary,
                fileData: fileData,
                fileHeader: header,
                fields: fields
            )
            let boundaryData = Data(boundary.utf8)
            let headerData = Data(header.utf8)
            let values = fields.compactMap(\.1).map { Data($0.utf8) }
            let collides = values.contains { $0.range(of: boundaryData) != nil } ||
                fileData.range(of: boundaryData) != nil ||
                headerData.range(of: boundaryData) != nil
            if !collides {
                self.data = data
                self.contentType = "multipart/form-data; boundary=\(boundary)"
                return
            }
        }
        throw .boundaryGenerationFailed
    }

    private static func makeData(
        boundary: String,
        fileData: Data,
        fileHeader: String,
        fields: [(String, String?)]
    ) -> Data {
        var data = Data()
        let prefix = Data("--\(boundary)\r\n".utf8)
        for (name, value) in fields {
            guard let value else { continue }
            data.append(prefix)
            data.append(Data("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".utf8))
            data.append(Data(value.utf8))
            data.append(Data("\r\n".utf8))
        }
        data.append(prefix)
        data.append(Data("\(fileHeader)\r\n\r\n".utf8))
        data.append(fileData)
        data.append(Data("\r\n--\(boundary)--\r\n".utf8))
        return data
    }

}
