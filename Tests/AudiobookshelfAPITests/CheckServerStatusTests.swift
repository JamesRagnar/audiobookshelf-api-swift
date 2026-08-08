import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct CheckServerStatusTests {

    // MARK: Full payload

    @Test
    func fullPayloadDecodes() throws {
        let json = """
        {
          "app": "audiobookshelf",
          "serverVersion": "2.33.0",
          "isInit": true,
          "language": "en-us",
          "authMethods": ["local"],
          "authFormData": {
            "authLoginCustomMessage": "Welcome back",
            "authOpenIDButtonText": "Sign in with SSO",
            "authOpenIDAutoLaunch": false
          }
        }
        """

        let response = try decode(json)

        #expect(response.app == "audiobookshelf")
        #expect(response.serverVersion == "2.33.0")
        #expect(response.isInit == true)
        #expect(response.language == "en-us")
        #expect(response.authMethods == ["local"])
        #expect(response.configPath == nil)
        #expect(response.metadataPath == nil)

        #expect(response.authFormData?.authLoginCustomMessage == "Welcome back")
        #expect(response.authFormData?.authOpenIDButtonText == "Sign in with SSO")
        #expect(response.authFormData?.authOpenIDAutoLaunch == false)
    }

    // MARK: Uninitialised server paths

    @Test
    func uninitializedPayloadIncludesPaths() throws {
        let json = """
        {
          "app": "audiobookshelf",
          "serverVersion": "2.33.0",
          "isInit": false,
          "language": "en-us",
          "authMethods": ["local"],
          "authFormData": { "authLoginCustomMessage": null },
          "ConfigPath": "/config",
          "MetadataPath": "/metadata"
        }
        """

        let response = try decode(json)

        #expect(response.isInit == false)
        #expect(response.configPath == "/config")
        #expect(response.metadataPath == "/metadata")
    }

    // MARK: authFormData absent (pre-2.31 servers)

    @Test
    func missingAuthFormDataDecodesAsNil() throws {
        let json = """
        {
          "app": "audiobookshelf",
          "serverVersion": "2.26.0",
          "isInit": true,
          "language": "en-us",
          "authMethods": ["local"]
        }
        """

        let response = try decode(json)

        #expect(response.serverVersion == "2.26.0")
        #expect(response.authFormData == nil)
    }

    // MARK: Helpers

    private func decode(_ json: String) throws -> CheckServerStatus.Response {
        try JSONDecoder().decode(CheckServerStatus.Response.self, from: Data(json.utf8))
    }

}
