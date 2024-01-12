//
//  FootballTeamView.swift
//  football-app
//
//  Created by James on 11/01/2024.
//

import Foundation
import UIKit

class FootballTeamView: UIView {
    lazy var logoImageView: UIImageView = makeLogoImageView()
    lazy var nameLabel: UILabel = makeNameLabel()

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    private func setupViews() {
        addSubview(logoImageView)
        addSubview(nameLabel)
    
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true

        nameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 4).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLogoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.constrainWidth(50)
        imageView.constrainHeight(50)
        return imageView
    }

    private func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false

        let width: CGFloat = screenWidth / 4
        label.constrainWidth(width)

        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        return label
    }
}
