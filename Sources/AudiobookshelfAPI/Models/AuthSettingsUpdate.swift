//
//  AuthSettingsUpdate.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-02-04.
//

import Foundation
import RagnarNetworking

/// Update payload for `/api/auth-settings`.
/// Note: This endpoint differentiates between omitted fields (no change) and explicit JSON null (clear value).
/// Use `Nullable.null` to send JSON null; use `nil` to omit the field.
public struct AuthSettingsUpdate: Encodable, Sendable, RequestBody {

    public var authLoginCustomMessage: Nullable<String>?
    public var authActiveAuthMethods: [String]?

    public var authOpenIDIssuerURL: Nullable<String>?
    public var authOpenIDAuthorizationURL: Nullable<String>?
    public var authOpenIDTokenURL: Nullable<String>?
    public var authOpenIDUserInfoURL: Nullable<String>?
    public var authOpenIDJwksURL: Nullable<String>?
    public var authOpenIDLogoutURL: Nullable<String>?
    public var authOpenIDClientID: Nullable<String>?
    public var authOpenIDClientSecret: Nullable<String>?
    public var authOpenIDTokenSigningAlgorithm: Nullable<String>?
    public var authOpenIDButtonText: Nullable<String>?
    public var authOpenIDAutoLaunch: Bool?
    public var authOpenIDAutoRegister: Bool?
    public var authOpenIDMatchExistingBy: Nullable<String>?
    public var authOpenIDMobileRedirectURIs: [String]?
    public var authOpenIDGroupClaim: Nullable<String>?
    public var authOpenIDAdvancedPermsClaim: Nullable<String>?
    public var authOpenIDSubfolderForRedirectURLs: Nullable<String>?

    public init(
        authLoginCustomMessage: Nullable<String>? = nil,
        authActiveAuthMethods: [String]? = nil,
        authOpenIDIssuerURL: Nullable<String>? = nil,
        authOpenIDAuthorizationURL: Nullable<String>? = nil,
        authOpenIDTokenURL: Nullable<String>? = nil,
        authOpenIDUserInfoURL: Nullable<String>? = nil,
        authOpenIDJwksURL: Nullable<String>? = nil,
        authOpenIDLogoutURL: Nullable<String>? = nil,
        authOpenIDClientID: Nullable<String>? = nil,
        authOpenIDClientSecret: Nullable<String>? = nil,
        authOpenIDTokenSigningAlgorithm: Nullable<String>? = nil,
        authOpenIDButtonText: Nullable<String>? = nil,
        authOpenIDAutoLaunch: Bool? = nil,
        authOpenIDAutoRegister: Bool? = nil,
        authOpenIDMatchExistingBy: Nullable<String>? = nil,
        authOpenIDMobileRedirectURIs: [String]? = nil,
        authOpenIDGroupClaim: Nullable<String>? = nil,
        authOpenIDAdvancedPermsClaim: Nullable<String>? = nil,
        authOpenIDSubfolderForRedirectURLs: Nullable<String>? = nil
    ) {
        self.authLoginCustomMessage = authLoginCustomMessage
        self.authActiveAuthMethods = authActiveAuthMethods
        self.authOpenIDIssuerURL = authOpenIDIssuerURL
        self.authOpenIDAuthorizationURL = authOpenIDAuthorizationURL
        self.authOpenIDTokenURL = authOpenIDTokenURL
        self.authOpenIDUserInfoURL = authOpenIDUserInfoURL
        self.authOpenIDJwksURL = authOpenIDJwksURL
        self.authOpenIDLogoutURL = authOpenIDLogoutURL
        self.authOpenIDClientID = authOpenIDClientID
        self.authOpenIDClientSecret = authOpenIDClientSecret
        self.authOpenIDTokenSigningAlgorithm = authOpenIDTokenSigningAlgorithm
        self.authOpenIDButtonText = authOpenIDButtonText
        self.authOpenIDAutoLaunch = authOpenIDAutoLaunch
        self.authOpenIDAutoRegister = authOpenIDAutoRegister
        self.authOpenIDMatchExistingBy = authOpenIDMatchExistingBy
        self.authOpenIDMobileRedirectURIs = authOpenIDMobileRedirectURIs
        self.authOpenIDGroupClaim = authOpenIDGroupClaim
        self.authOpenIDAdvancedPermsClaim = authOpenIDAdvancedPermsClaim
        self.authOpenIDSubfolderForRedirectURLs = authOpenIDSubfolderForRedirectURLs
    }
}
