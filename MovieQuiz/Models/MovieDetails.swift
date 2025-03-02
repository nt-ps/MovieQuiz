import Foundation

final class MovieDetails: Codable {
    
    // MARK: - Internal Properties
    
    let imageURL: URL
    let title: String
    let rating: Float
    
    // MARK: - Private Properties
    
    private enum ParseError: Error {
        case ratingFailure
    }
    
    private var cachedImageData: Data?
    
    private var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        
        return newURL
    }
    
    // MARK: - Private Enumerations
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
    
    // MARK: - Initializers
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        
        let rating = try container.decode(String.self, forKey: .rating)
        guard let ratingValue = Float(rating) else {
            throw ParseError.ratingFailure
        }
        self.rating = ratingValue
        
        imageURL = try container.decode(URL.self, forKey: .imageURL)
    }
    
    // MARK: - Internal Methods
    
    func getImageData() throws -> Data {
        if let image: Data = cachedImageData {
            return image
        } else {
            do {
                cachedImageData = try Data(contentsOf: resizedImageURL)
                return cachedImageData ?? Data()
            } catch {
                throw error
            }
        }
    }
}
