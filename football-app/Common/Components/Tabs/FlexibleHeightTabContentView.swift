//
//  FlexibleHeightTabContent.swift
//  football-app
//
//  Created by James on 10/01/2024.
//

import Foundation
import UIKit

public protocol FlexibleHeightTabContentViewDelegate: AnyObject {
    func tabContent(_ content: FlexibleHeightTabContentView, scrollToProgress progress: CGFloat, bySwipe: Bool)
    func tabContent(_ content: FlexibleHeightTabContentView, didScrollToIndex index: Int, bySwipe: Bool)
    func tabContentRequestLayoutIfNeeded(_ content: FlexibleHeightTabContentView)
}

open class FlexibleHeightTabContentView: UIView {
    let count: Int

    public weak var delegate: FlexibleHeightTabContentViewDelegate?

    var scrollViewHeightConstraint: NSLayoutConstraint?

    public var animationDuration = 0.3

    var isScrollingBySwipe = true

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let tabs = (0..<self.count).map { _ in self.createTabContent() }
        for (index, tab) in tabs.enumerated() {
            scrollView.addSubview(tab)
            tab.anchor([
                .top(scrollView.topAnchor),
                .leading(index == 0 ? scrollView.leadingAnchor : tabs[index - 1].trailingAnchor)
            ])
            scrollView.widthAnchor.constraint(equalTo: tab.widthAnchor).isActive = true
            if index == tabs.count - 1 {
                tab.anchor([
                    .trailing(scrollView.trailingAnchor)
                ])
            }
        }
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollViewHeightConstraint = scrollView.heightAnchor.constraint(equalTo: tabs[0].heightAnchor)
        scrollViewHeightConstraint?.isActive = true
        scrollView.delegate = self
        return scrollView
    }()

    public init(count: Int) {
        self.count = count
        super.init(frame: .zero)
        setup()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubview(scrollView)
        scrollView.fillSuperview()
    }

    func update() {
        let index = Int((scrollView.contentOffset.x / scrollView.bounds.width).rounded())
        delegate?.tabContent(self, didScrollToIndex: index, bySwipe: isScrollingBySwipe)
        if let constraint = scrollViewHeightConstraint {
            scrollView.removeConstraint(constraint)
        }
        scrollViewHeightConstraint = scrollView.heightAnchor.constraint(
            equalTo: scrollView.subviews[index].heightAnchor)
        scrollViewHeightConstraint?.isActive = true
        UIView.animate(withDuration: animationDuration, delay: 0, options: .allowUserInteraction) {[weak self] in
            guard let self = self else { return }
            self.delegate?.tabContentRequestLayoutIfNeeded(self)
        }
    }

    func createTabContent() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }

    public func scrollToIndex(_ index: Int) {
        let x = CGFloat(index) * scrollView.bounds.width
        isScrollingBySwipe = false
        scrollView.setContentOffset(.init(x: x, y: 0), animated: true)
    }

    public func contentAt(index: Int) -> UIStackView? {
        return scrollView.subviews[index] as? UIStackView
    }
}


extension FlexibleHeightTabContentView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.tabContent(
            self,
            scrollToProgress: scrollView.contentOffset.x / scrollView.bounds.width,
            bySwipe: isScrollingBySwipe
        )
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrollingBySwipe = true
        update()
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        update()
    }
}

