
import Foundation
import UIKit

class ImageDownloader {
    private let imageCache = ImageCache()
    
    func downloadImage(from url: URL) async throws -> UIImage {
        if let cachedImage = imageCache.image(for: url) {
            return cachedImage
        }
        
        let data = try await downloadImageData(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "InvalidImageData", code: 0, userInfo: nil)
        }
        
        imageCache.cacheImage(image, for: url)
        return image
    }
    
    func downloadImageData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
