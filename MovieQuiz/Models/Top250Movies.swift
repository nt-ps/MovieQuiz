import Foundation

struct Top250Movies: Codable {
    
    // MARK: - Internal Properties
    
    let error: TVAPIError?
    let items: [MovieDetails]
    
    // MARK: - Private Properties
    
    private let errorMessage: String
    
    // MARK: - Internal Enumerations
    
    enum TVAPIError: Error, LocalizedError {
        case message(String)
        
        public var errorDescription: String? {
            switch self {
            case .message(let errorMessage):
                return NSLocalizedString(errorMessage, comment: "TV-API Error.")
            }
        }
        
    }
    
    // MARK: - Private Enumerations
    
    private enum CodingKeys: String, CodingKey {
        case errorMessage = "errorMessage"
        case items = "items"
    }
    
    // MARK: - Initializers
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        errorMessage = try container.decode(String.self, forKey: .errorMessage)
        error = !errorMessage.isEmpty ? TVAPIError.message(errorMessage) : nil
        
        items = try container.decode([MovieDetails].self, forKey: .items)
    }
}
