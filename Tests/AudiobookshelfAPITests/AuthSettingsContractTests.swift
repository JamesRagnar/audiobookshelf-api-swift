import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct AuthSettingsContractTests {

    @Test
    func adminResponseDecodesNullableOpenIDFieldsAndSampleString() throws {
        let response = try JSONDecoder().decode(
            GetAuthSettings.Response.self,
            from: Data(
                """
                {
                  "authLoginCustomMessage": null,
                  "authActiveAuthMethods": ["password"],
                  "authOpenIDTokenSigningAlgorithm": null,
                  "authOpenIDButtonText": null,
                  "authOpenIDAutoLaunch": false,
                  "authOpenIDAutoRegister": false,
                  "authOpenIDClientID": null,
                  "authOpenIDClientSecret": null,
                  "authOpenIDMobileRedirectURIs": null,
                  "authOpenIDGroupClaim": null,
                  "authOpenIDAdvancedPermsClaim": null,
                  "authOpenIDSamplePermissions": "{\\"root\\":false}"
                }
                """.utf8
            )
        )

        #expect(response.authOpenIDTokenSigningAlgorithm.isEmpty)
        #expect(response.authOpenIDButtonText.isEmpty)
        #expect(response.authOpenIDMobileRedirectURIs == nil)
        #expect(response.authOpenIDSamplePermissions == "{\"root\":false}")
    }

    @Test
    func adminResponseRejectsMissingRequiredSample() {
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(
                GetAuthSettings.Response.self,
                from: Data(
                    """
                    {
                      "authLoginCustomMessage": null,
                      "authActiveAuthMethods": [],
                      "authOpenIDAutoLaunch": false,
                      "authOpenIDAutoRegister": false
                    }
                    """.utf8
                )
            )
        }
    }

    @Test
    func adminResponseDefaultsMissingLegacyStringsToEmpty() throws {
        let response = try JSONDecoder().decode(
            GetAuthSettings.Response.self,
            from: Data(
                """
                {
                  "authActiveAuthMethods": [],
                  "authOpenIDAutoLaunch": false,
                  "authOpenIDAutoRegister": false,
                  "authOpenIDSamplePermissions": "{}"
                }
                """.utf8
            )
        )

        #expect(response.authOpenIDTokenSigningAlgorithm.isEmpty)
        #expect(response.authOpenIDButtonText.isEmpty)
    }

}
