//
//  UIViewExtentions.swift
//  football-app
//
//  Created by James on 10/01/2024.
//

import Foundation
import UIKit

extension UIView {
    static func spacing(height: CGFloat = 1, backgroundColor: UIColor = .lightGray) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.constrainHeight(height)
        return view
    }

    func addDropShadow(color: UIColor = UIColor.black,
                       shadowOffset: CGSize = CGSize(width: 2, height: 2),
                       alpha: Float = 0.3,
                       blur: CGFloat? = nil,
                       spread: CGFloat? = nil) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = alpha
        if let shadowRadius = blur {
            layer.shadowRadius = shadowRadius / 2
        }
        if let spread = spread {
            let dx = -spread
            let rect = layer.bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }

    func setupCornerRadius(_ cornerRadius: CGFloat = 0, maskedCorners: CACornerMask? = nil) {
        layer.cornerRadius = cornerRadius
        if let corners = maskedCorners {
            layer.maskedCorners = corners
        }
    }
}

@objc class ClosureSleeve: NSObject {
    let closure: () -> Void

    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }

    @objc func invoke() {
        closure()
    }
}

extension UIView: UIGestureRecognizerDelegate {
    /// Allows adding tap detection to any UIView
    /// - Parameter closure: the method to run
    public func addActionOnTap(_ closure: @escaping () -> Void) {
        let sleeve = ClosureSleeve(closure)
        let tapGesture = UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
        objc_setAssociatedObject(
            self,
            "[\(Int.random(in: 1...Int.max))]",
            sleeve,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }
}
