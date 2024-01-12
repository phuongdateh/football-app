//
//  UIStackView+Extensions.swift
//  football-app
//
//  Created by James on 11/01/2024.
//

import Foundation
import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }

    func setPadding(_ inset: UIEdgeInsets) {
        layoutMargins = inset
        isLayoutMarginsRelativeArrangement = true
    }
}

