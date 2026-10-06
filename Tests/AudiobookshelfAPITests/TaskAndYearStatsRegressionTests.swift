import AudiobookshelfAPI
import Foundation
import Testing

private typealias Fixtures = MaintainedContractFixtures

@Suite
struct TaskAndYearStatsRegressionTests {

    @Test(arguments: [false, true])
    func taskSubstitutionsRetainHeterogeneousValues(isFinished: Bool) throws {
        var object = try Fixtures.object(Fixtures.task)
        object["action"] = "import-opml"
        object["isFinished"] = isFinished
        object["finishedAt"] = isFinished ? 2000 : NSNull()
        object["titleSubs"] = [2, "podcasts", NSNull()]
        object["descriptionSubs"] = [2, "imported", NSNull()]
        object["errorSubs"] = [2, "failed", NSNull()]
        let json = try Fixtures.json(object)
        let rest = try Fixtures.response(GetTasks.self, "{\"tasks\":[\(json)]}")
        let started = try Fixtures.decode(TaskStarted.Schema.self, json)
        let finished = try Fixtures.decode(TaskFinished.Schema.self, json)
        try expectSubstitutions(try #require(rest.tasks.first))
        try expectSubstitutions(started)
        try expectSubstitutions(finished)
    }

    @Test
    func completeYearStatsAcceptNullLongestAudiobookTitle() throws {
        var object = try Fixtures.object(Fixtures.userYear)
        var longest = try #require(object["longestAudiobookFinished"] as? [String: Any])
        longest["title"] = NSNull()
        object["longestAudiobookFinished"] = longest
        let response = try Fixtures.response(GetYearStats.self, Fixtures.json(object))
        let audiobook = try #require(response.longestAudiobookFinished)
        #expect(audiobook.title == nil)
        #expect(audiobook.id == "book-1")
        #expect(audiobook.duration == 120)
        #expect(audiobook.finishedAt.timeIntervalSince1970 == 1_767_225_600.125)
        #expect(response.totalListeningTime == 90)
        #expect(response.numBooksFinished == 1)
    }

    @Test
    func longestAudiobookRejectsNonStringTitle() throws {
        let json = """
        {"id":"book-1","title":2,"duration":120,"finishedAt":"2026-01-01T00:00:00Z"}
        """
        #expect(throws: DecodingError.self) { try Fixtures.decode(YearStats.LongestAudiobook.self, json) }
    }

    private func expectSubstitutions(_ task: BackgroundTask) throws {
        try expectValues(task.titleSubs, text: "podcasts")
        try expectValues(task.descriptionSubs, text: "imported")
        try expectValues(task.errorSubs, text: "failed")
    }

    private func expectValues(_ optionalValues: [JSONValue]?, text: String) throws {
        let values = try #require(optionalValues)
        try #require(values.count == 3)
        guard case .number(let count) = values[0],
              case .string(let string) = values[1],
              case .null = values[2] else {
            Issue.record("Expected numeric count, string and null substitution values")
            return
        }
        #expect(count == 2)
        #expect(string == text)
    }

}
