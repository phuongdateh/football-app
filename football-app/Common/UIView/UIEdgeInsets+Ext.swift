//
//  UIEdgeInsets+Ext.swift
//  football-app
//
//  Created by James on 10/01/2024.
//

import Foundation
import UIKit

extension UIEdgeInsets {

    static public func horizontalSides(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: side, bottom: 0, right: side)
    }

    static public func verticalSides(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: side, left: 0, bottom: side, right: 0)
    }

    static public func allSides(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: side, left: side, bottom: side, right: side)
    }

    static public func sides(horizontal: CGFloat, vertical: CGFloat) -> UIEdgeInsets {
        return .init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

extension UIScrollView {
    public func scrollTo(horizontalPage: Int? = 0, verticalPage: Int? = 0, animated: Bool? = true) {
        var frame: CGRect = self.frame
        frame.origin.x = frame.size.width * CGFloat(horizontalPage ?? 0)
        frame.origin.y = frame.size.width * CGFloat(verticalPage ?? 0)
        self.scrollRectToVisible(frame, animated: animated ?? true)
    }
    
    public func hideIndicators() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
}
