//
//  StandardTabsView.swift
//  football-app
//
//  Created by James on 10/01/2024.
//

import Foundation
import UIKit

public enum TextCase {
  case none
  case uppercase
  case lowercase
}

struct TextStyle {
    public var font: UIFont
    public var lineHeight: CGFloat = 0
    public var letterSpacing: CGFloat = 0
    public var textCase: TextCase = .none

    static let bodyMediumRegular: TextStyle = TextStyle(font: .systemFont(ofSize: 14, weight: .regular))
    static let bodyMediumMedium: TextStyle = TextStyle(font: .systemFont(ofSize: 14, weight: .medium))
}

public protocol StandardTabsDelegate: AnyObject {
    func standardTabs(_ sender: StandardTabsView, didSelectIndex: Int)
}

public enum StandardTabsStyle {
    case `default`
    case segmented
    case segmentedCenter

    var leftPadding: CGFloat {
        switch self {
        case .default:
            return 12
        case .segmented:
            return 20
        case .segmentedCenter:
            return 20
        }
    }
}

open class StandardTabsView: UIStackView {
    public let titles: [String]
    weak public var delegate: StandardTabsDelegate?

    public var selectedIndex = 0
    var progress = 0.0

    var indicatorWidth: CGFloat {
        return bounds.width / CGFloat(titles.count)
    }

    lazy var indicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    public var isEnabled = true {
        didSet {
            updateEnabledState()
        }
    }

    lazy var backgroundIndicator: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()

    lazy var segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl()
        for (index, title) in titles.enumerated() {
            view.insertSegment(withTitle: title, at: index, animated: true)
            switch style {
            case .segmented:
                view.setWidth(segmentWidth, forSegmentAt: index)
            case .segmentedCenter:
                let width: Double = (screenWidth - 2 * style.leftPadding) / CGFloat(titles.count)
                view.setWidth(width, forSegmentAt: index)
            default:
                break
            }
        }
        return view
    }()

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        delegate?.standardTabs(self, didSelectIndex: sender.selectedSegmentIndex)
    }

    var style: StandardTabsStyle
    var indicatorSpacing: Double
    var titleTextStyle: TextStyle
    var segmentWidth: Double

    init(titles: [String],
         titleTextStyle: TextStyle = .bodyMediumRegular,
         style: StandardTabsStyle = .default,
         indicatorSpacing: Double = 8.0,
         segmentWidth: Double = 120) {
        self.titles = titles
        self.style = style
        self.indicatorSpacing = indicatorSpacing
        self.titleTextStyle = titleTextStyle
        self.segmentWidth = segmentWidth
        super.init(frame: .zero)
        setup()
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var titleList: [UILabel] = [UILabel]()
}

// MARK: - Helpers
extension StandardTabsView {
    func setup() {
        guard style == .default else {
            setupSegmentedControlUI()
            return
        }

        addSubview(indicator)

        titleList.removeAll()
        for (index, title) in titles.enumerated() {
            let label: UILabel = UILabel()
            label.text = title
            label.tag = index
            label.isUserInteractionEnabled = true
            label.addActionOnTap {[weak self] in
                self?.selectIndex(index)
            }
            label.textAlignment = .center
            addArrangedSubview(label)

            titleList.append(label)
        }
        addArrangedSubview(UIView())
        updateLabels()
        spacing = 24

        addSubview(backgroundIndicator)
        self.backgroundIndicator.anchor([
            .top(topAnchor, constant: 47),
            .leading(leadingAnchor),
            .trailing(trailingAnchor)
        ])
        sendSubviewToBack(backgroundIndicator)
    }

    func setupSegmentedControlUI() {
        let selectedAttribute = [
            NSAttributedString.Key.font: TextStyle.bodyMediumMedium.font,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let lightUnSelectedAttribute = [
            NSAttributedString.Key.font: TextStyle.bodyMediumRegular.font,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
//        let darkUnSelectedAttribute = [
//            NSAttributedString.Key.font: TextStyle.bodyMediumRegular.font,
//            NSAttributedString.Key.foregroundColor: UIColor.lightGray
//        ]
//        segmentedControl.theme_setTitleTextAttributes([selectedAttribute, selectedAttribute], forState: .selected)
//        segmentedControl.theme_setTitleTextAttributes([darkUnSelectedAttribute, lightUnSelectedAttribute], forState: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttribute, for: .selected)
        segmentedControl.setTitleTextAttributes(lightUnSelectedAttribute, for: .normal)

        segmentedControl.setupCornerRadius(5)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = UIColor.darkGray
//        segmentedControl.theme_backgroundColor = UIColor.dynamic(light: UIColors.black20, dark: UIColors.dark3)
        segmentedControl.backgroundColor = UIColor.lightGray
        addArrangedSubview(segmentedControl)
    }

    func update() {
        // not required
    }

    func updateIndicator() {
        let currentFrame: CGRect = titleList[selectedIndex].frame

        indicator.frame = CGRect(
            x: currentFrame.origin.x - 8,
            y: Double(bounds.height) - (14 - indicatorSpacing),
            width: currentFrame.width + 16,
            height: 2.0)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        guard style == .default else {
            return
        }
        updateIndicator()
    }

    public func updateProgress(_ progress: Double) {
        guard style == .default else { return }
        self.progress = progress
        updateIndicator()
    }

    public func updateLabels() {
        for label in arrangedSubviews {
            if let label = label as? UILabel {
                label.font = selectedIndex == label.tag ? TextStyle.bodyMediumMedium.font : TextStyle.bodyMediumRegular.font
                label.textColor = selectedIndex == label.tag
                ? UIColor.purple
                : UIColor.white
            }
        }
    }

    public func selectIndex(_ index: Int, animationDuration: TimeInterval = 0.3, callDelegate: Bool = true) {
        guard style == .default else {
            segmentedControl.selectedSegmentIndex = index
            return
        }
        guard isEnabled else {
            return
        }
        self.progress = 0
        self.selectedIndex = index
        updateLabels()
        if animationDuration > 0 {
            UIView.animate(withDuration: animationDuration) {
                self.updateIndicator()
            }
        } else {
            updateIndicator()
        }
        if callDelegate {
            delegate?.standardTabs(self, didSelectIndex: index)
        }
    }

    public func updateEnabledState() {
        for view in self.subviews {
            if let label = view as? UILabel {
                label.isEnabled = isEnabled
            }
        }
        indicator.isHidden = !isEnabled
    }
}
