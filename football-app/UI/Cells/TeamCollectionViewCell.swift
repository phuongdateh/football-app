//
//  TeamCollectionViewCell.swift
//  football-app
//
//  Created by James on 09/01/2024.
//

import Foundation
import UIKit

class TeamCollectionViewCell: UICollectionViewCell {
    lazy var nameLabel: UILabel = makeNameLabel()
    lazy var logoImageView: UIImageView = makeLogoImageView()
    lazy var shadowBackgroundView: UIView = makeShadowBackgroundView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(shadowBackgroundView)
        shadowBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        shadowBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        shadowBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        shadowBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true

        shadowBackgroundView.addSubview(logoImageView)
        shadowBackgroundView.addSubview(nameLabel)

        logoImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: shadowBackgroundView.leadingAnchor, constant: 8).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: shadowBackgroundView.centerYAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: shadowBackgroundView.topAnchor, constant: 8).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: shadowBackgroundView.bottomAnchor, constant: -8).isActive = true

        nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor).isActive = true
    }

    private func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func makeLogoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func makeShadowBackgroundView() -> UIView {
        let shadowView = UIView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.addDropShadow()
        shadowView.layer.borderColor = UIColor.gray.cgColor
        shadowView.layer.borderWidth = 1
        shadowView.layer.cornerRadius = 8
        return shadowView
    }
}
