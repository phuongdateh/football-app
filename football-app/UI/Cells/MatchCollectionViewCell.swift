//
//  MatchCollectionViewCell.swift
//  football-app
//
//  Created by James on 10/01/2024.
//

import Foundation
import UIKit

protocol MatchCollectionViewCellDelegate: AnyObject {
    func matchCollectionViewCell(_ cell: MatchCollectionViewCell, didSelect highlights: String?)
}

class MatchCollectionViewCell: UICollectionViewCell {
    lazy var stackView: UIStackView = makeMainStackView()
    lazy var dateSectionView: UIView = makeDataSectionView()
    lazy var hourMatchLabel: UILabel = makeHourMatchLabel()
    lazy var dateMatchLabel: UILabel = makeDateMatchLabel()
    lazy var mainView: UIView = makeMainView()
    lazy var descriptionLabel: UILabel = makeDescriptionLabel()
    lazy var homeTeamView: FootballTeamView = makeHomeTeamView()
    lazy var awayTeamView: FootballTeamView = makeAwayTeamView()
    lazy var statusMatchLabel: UILabel = makeStatusMatchLabel()
    lazy var highlightsView: UIView = makeHighlightsView()

    weak var delegate: MatchCollectionViewCellDelegate?
    var data: FootballMatch!

    func update(_ model: FootballMatch) {
        self.data = model
        highlightsView.isHidden = model.highlights == nil
        statusMatchLabel.attributedText = model.statuOfMatch()
        hourMatchLabel.text = model.hourOfMatch()
        dateMatchLabel.text = model.dateOfMatch()

        homeTeamView.nameLabel.text = model.home?.replacingOccurrences(of: "Team", with: "")
        awayTeamView.nameLabel.text = model.away?.replacingOccurrences(of: "Team", with: "")

        descriptionLabel.text = model.description
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }

    private func makeMainStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical

        stackView.addArrangedSubviews([
            dateSectionView,
            lineSepartionView(),
            mainView,
            lineSepartionView(),
            makeDescriptionMatchView(),
            lineSepartionView(),
            highlightsView
        ])

        stackView.setupCornerRadius(8)
        stackView.addDropShadow()
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.gray.cgColor

        return stackView
    }

    private func lineSepartionView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.constrainHeight(1)
        return view
    }

    private func makeHighlightsView() -> UIView {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.red
        label.text = "Video"
        label.font = .systemFont(ofSize: 14, weight: .bold)

        let stackView: UIStackView = UIStackView(arrangedSubviews: [label])
        stackView.setPadding(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 0))
        stackView.addActionOnTap {
            self.delegate?.matchCollectionViewCell(self, didSelect: self.data.highlights)
        }
        return stackView
    }

    private func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }

    private func makeDescriptionMatchView() -> UIView {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [descriptionLabel])
        stackView.setPadding(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 0))
        return stackView
    }

    private func makeDateMatchLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }

    private func makeHourMatchLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }

    private func makeDataSectionView() -> UIView {
        let view = UIView()
        view.addSubview(hourMatchLabel)
        view.addSubview(dateMatchLabel)

        hourMatchLabel.anchor([.top(view.topAnchor, constant: 8),
                               .leading(view.leadingAnchor, constant: 8),
                               .bottom(view.bottomAnchor, constant: 8)])
        dateMatchLabel.centerInSuperview()
        return view
    }

    private func makeMainView() -> UIView {
        let view = UIView()
        view.addSubview(homeTeamView)
        view.addSubview(awayTeamView)
        view.addSubview(statusMatchLabel)

        homeTeamView.anchor([.leading(view.leadingAnchor, constant: 8),
                             .top(view.topAnchor, constant: 8),
                             .bottom(view.bottomAnchor, constant: 8)])
        awayTeamView.anchor([.trailing(view.trailingAnchor, constant: 8),
                             .top(view.topAnchor, constant: 8),
                             .bottom(view.bottomAnchor, constant: 8)])
        statusMatchLabel.centerInSuperview()
        return view
    }

    private func makeHomeTeamView() -> FootballTeamView {
        FootballTeamView()
    }

    private func makeAwayTeamView() -> FootballTeamView {
        FootballTeamView()
    }

    private func makeStatusMatchLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
