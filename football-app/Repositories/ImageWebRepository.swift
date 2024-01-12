//
//  ImageWebRepository.swift
//  football-app
//
//  Created by James on 10/01/2024.
//

import Foundation
import UIKit
import Combine

struct RealImageWebRepository: ImageWebRepository {
    private var imageCache: NSCache<NSString, UIImage>
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(imageCache: NSCache<NSString, UIImage> = NSCache(),
         session: URLSession = .defaultConfigured(),
         baseURL: String) {
        self.imageCache = imageCache
        self.session = session
        self.baseURL = baseURL
    }
    
    func load(imageURL: URL) -> AnyPublisher<UIImage, Error> {
        return download(rawImageURL: imageURL)
            .subscribe(on: bgQueue)
            .receive(on: DispatchQueue.main)
            .extractUnderlyingError()
            .eraseToAnyPublisher()
    }
    
    private func download(rawImageURL: URL) -> AnyPublisher<UIImage, Error> {
        if let cachedImage = imageCache.object(forKey: rawImageURL.absoluteString as NSString) {
            return Just<UIImage>
                .withErrorType(cachedImage, Error.self)
                .eraseToAnyPublisher()
        }

        let urlRequest = URLRequest(url: rawImageURL)
        return session.dataTaskPublisher(for: urlRequest)
            .requestData()
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw APIError.imageDeserialization
                }
                // Cached
                imageCache.setObject(image, forKey: rawImageURL.absoluteString as NSString)
                return image
            }
            .eraseToAnyPublisher()
    }
}
