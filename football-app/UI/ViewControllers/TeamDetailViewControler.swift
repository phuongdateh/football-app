//
//  TeamDetailViewControler.swift
//  football-app
//
//  Created by James on 11/01/2024.
//

import Foundation
import UIKit

final class TeamDetailViewControler: UIViewController {
    // Should not using this way
    // Now can accept it
    // We should pass only id then get from CoreData
    let team: FootballTeam
    lazy var viewModel: TeamDetailViewModel = RealTeamDetailViewModel()

    lazy var mainStackView: UIStackView = makeMainStackView()
    lazy var teamView: FootballTeamView = makeTeamView()
    lazy var upcomingMatchesView: MatchesView = makeUpcomingMatchesView()
    lazy var previousMatchesView: MatchesView = makePreviousMatchesView()
    lazy var tabsView: FlexibleHeightTabView = makeTabsView()

    init(team: FootballTeam) {
        self.team = team
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindingViewModels()
    }

    private func setupViews() {
        title = "Detail"
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        mainStackView.anchor([
            .top(view.safeAreaLayoutGuide.topAnchor, constant: 0),
            .leading(view.leadingAnchor, constant: 0),
            .trailing(view.trailingAnchor, constant: 0),
            .bottom(view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

    private let cancelBag: CancelBag = CancelBag()

    private func bindingViewModels() {
        viewModel.getPreviousMatches(of: team)
            .sinkToResult { [weak self] result in
                switch result {
                case .success(let list):
                    self?.previousMatchesView.matchesDidLoad(list)
                default:
                    break
                }
            }
            .store(in: cancelBag)

        viewModel.getUpcomingMatches(of: team)
            .sinkToResult { [weak self] result in
                switch result {
                case .success(let list):
                    self?.upcomingMatchesView.matchesDidLoad(list)
                default:
                    break
                }
            }
            .store(in: cancelBag)
    }

    // MARK: - Make views
    private func makeMainStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [
            teamView,
            UIView.spacing(),
            tabsView
        ])
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }

    private func makeTabsView() -> FlexibleHeightTabView {
        let view = FlexibleHeightTabView(titles: ["Upcoming", "Previous"], style: .segmented)
        view.contentAt(index: 0)?.addArrangedSubview(upcomingMatchesView)
        view.contentAt(index: 1)?.addArrangedSubview(previousMatchesView)
        return view
    }

    private func makeUpcomingMatchesView() -> MatchesView {
        let view = MatchesView()
        view.viewModel = viewModel
        return view
    }

    private func makePreviousMatchesView() -> MatchesView {
        let view = MatchesView()
        view.viewModel = viewModel
        view.delegate = self
        return view
    }

    private func makeTeamView() -> FootballTeamView {
        let view = FootballTeamView()
        view.logoImageView.load(from: team.logo ?? "")
        view.nameLabel.text = team.name?.replacingOccurrences(of: "Team", with: "")
        view.constrainHeight(90)
        return view
    }
}

extension TeamDetailViewControler: MatchesViewDelegate {
    func matchesView(_ view: MatchesView, didOpen highlights: String?) {
        presentPlayerViewControler(with: highlights)
    }
}
