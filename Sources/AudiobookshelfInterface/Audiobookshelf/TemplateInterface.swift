import Foundation

///
public struct File: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String = ""
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        public init() {}
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
    }
    
    public enum AudiobookshelfError: Error {
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}
