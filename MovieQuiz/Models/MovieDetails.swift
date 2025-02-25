import Foundation

class MovieDetails: Codable {
    
    private var cachedImageData: Data?
    private let imageURL: URL
    
    let title: String
    let rating: String
    
    var imageData: Data {
        if let image: Data = cachedImageData {
            return image;
        } else {
            do {
                cachedImageData = try Data(contentsOf: resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            return cachedImageData ?? Data()
        }
    }
    
    private var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
