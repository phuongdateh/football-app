//
//  ImagesService.swift
//  football-app
//
//  Created by James on 10/01/2024.
//

import Combine
import UIKit

struct RealImagesService: ImagesService {
    static let shared: ImagesService = RealImagesService()

    let webRepository: ImageWebRepository

    init(webRepository: ImageWebRepository = RealImageWebRepository(baseURL: "")) {
        self.webRepository = webRepository
    }

    func load(imageURL: URL) -> AnyPublisher<UIImage, Error> {
        webRepository.load(imageURL: imageURL)
    }
}

extension UIImageView {
    func load(from url: String) {
        let service: ImagesService = RealImagesService.shared
        guard let url = URL(string: url) else {
            return
        }
        let cancelBag = CancelBag()
        let indicatorView: UIActivityIndicatorView = makeLoadingIndicator()
        indicatorView.center = center

        service.load(imageURL: url)
            .receive(on: DispatchQueue.main)
            .sinkToResult { [weak self] result in
                switch result {
                case .success(let image):
                    self?.image = image
                case .failure(_):
                    // Should be placeholder image
                    self?.image = UIImage()
                }
                indicatorView.stopAnimating()
                indicatorView.removeFromSuperview()
            }
            .store(in: cancelBag)
    }

    private func makeLoadingIndicator() -> UIActivityIndicatorView {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        return activityIndicator
    }
}
