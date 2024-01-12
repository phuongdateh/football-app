//
//  FlexibleHeightTab.swift
//  football-app
//
//  Created by James on 10/01/2024.
//

import Foundation
import UIKit

open class FlexibleHeightTabView: UIStackView {
    let titles: [String]

    public weak var delegate: FlexibleHeightTabContentViewDelegate?

    public lazy var tabs: StandardTabsView = {
        let view = StandardTabsView(titles: titles, style: style, segmentWidth: segmentWidth)
        view.delegate = self
        return view
    }()

    private lazy var tabsView: UIView = {
        let vw = UIView()

        let scrollView = UIScrollView()
        if style == .default {
            scrollView.contentInset = UIEdgeInsets.horizontalSides(20)
        }
        scrollView.hideIndicators()
        scrollView.addSubview(tabs)
        tabs.fillSuperview(padding: UIEdgeInsets(top: 0, left: style.leftPadding, bottom: 0, right: 0))
        scrollView.heightAnchor.constraint(equalTo: tabs.heightAnchor).isActive = true

        vw.addSubview(scrollView)
        scrollView.fillSuperview()
        return vw
    }()

    lazy var tabContent: FlexibleHeightTabContentView = {
        let view = FlexibleHeightTabContentView(count: titles.count)
        view.delegate = self
        return view
    }()

    var style: StandardTabsStyle
    var segmentWidth: Double

    public init(titles: [String],
                style: StandardTabsStyle = .segmented,
                segmentWidth: Double = 120) {
        self.titles = titles
        self.style = style
        self.segmentWidth = segmentWidth
        super.init(frame: .zero)
        setup()
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - XStandardTabsDelegate
extension FlexibleHeightTabView: StandardTabsDelegate {
    public func standardTabs(_ sender: StandardTabsView, didSelectIndex: Int) {
        tabContent.scrollToIndex(didSelectIndex)
    }
}

// MARK: - FlexibleHeightTabContentDelegate
extension FlexibleHeightTabView: FlexibleHeightTabContentViewDelegate {
    public func tabContent(_ content: FlexibleHeightTabContentView, didScrollToIndex index: Int, bySwipe: Bool) {
        tabs.selectIndex(index, callDelegate: false)
        delegate?.tabContent(content, didScrollToIndex: index, bySwipe: bySwipe)
    }
    public func tabContent(_ content: FlexibleHeightTabContentView, scrollToProgress progress: CGFloat, bySwipe: Bool) {
        if bySwipe {
            tabs.updateProgress(Double(progress) - Double(tabs.selectedIndex))
        }
        delegate?.tabContent(content, scrollToProgress: progress, bySwipe: bySwipe)
    }
    public func tabContentRequestLayoutIfNeeded(_ content: FlexibleHeightTabContentView) {
        delegate?.tabContentRequestLayoutIfNeeded(content)
    }
}

// MARK: - Helpers
extension FlexibleHeightTabView {
    func setup() {
        axis = .vertical
        spacing = 4
        addArrangedSubview(tabsView)
        addArrangedSubview(tabContent)
    }

    public func contentAt(index: Int) -> UIStackView? {
        return tabContent.contentAt(index: index)
    }
}

