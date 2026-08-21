import Foundation

enum LibraryItemFilter {

    static func author(_ authorID: String) -> String {
        encoded(group: "authors", value: authorID)
    }

    static func narrator(_ narratorName: String) -> String {
        encoded(group: "narrators", value: narratorName)
    }

    static func series(_ seriesID: String) -> String {
        encoded(group: "series", value: seriesID)
    }

    private static func encoded(group: String, value: String) -> String {
        "\(group).\(Data(value.utf8).base64EncodedString())"
    }

}
