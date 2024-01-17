//
//  ViewController.swift
//  football-app
//
//  Created by James on 04/01/2024.
//

import UIKit
import Combine
import AVFoundation
import AVKit

class HomeViewController: UIViewController {
    // MARK: - ViewModel
    private lazy var viewModel: HomeViewModel = {
        RealHomeViewModel()
    }()

    // MARK: - Views Components
    private lazy var allTeamView: AllTeamView = makeTeamListView()
    private lazy var allMatchView: MatchesView = makeAllMatchView()
    private lazy var tabsView: FlexibleHeightTabView = makeTabsView()
    private lazy var searchView: UISearchBar = makeSearchView()

    private let cancelBag: CancelBag = CancelBag()

    deinit {
        cancelBag.cancel()
    }

    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let output = viewModel.transform(input: searchView.searchTextField.texPublisher)

        output.teames
            .sinkToResult { [weak self] result in
                switch result {
                case .success(let list):
                    self?.allTeamView.teamsDidLoad(list)
                case .failure(let error):
                    guard let error = error as? APIError else {
                        print(error.localizedDescription)
                        return
                    }
                    print(error.localizedDescription)
                }
            }
            .store(in: cancelBag)

        output.matches
            .sinkToResult { [weak self] resutl in
                switch resutl {
                case .success(let matches):
                    self?.allMatchView.matchesDidLoad(matches)
                default:
                    break
                }
            }
            .store(in: cancelBag)
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: searchView.searchTextField)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = UIColor.white

        let containerView: UIStackView = UIStackView(arrangedSubviews: [searchView, tabsView])
        containerView.axis = .vertical
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.trailingAnchor)
    }

    // MARK: - Make views
    private func makeSearchView() -> UISearchBar {
        let searchView: UISearchBar = UISearchBar()
        searchView.constrainHeight(80)
        return searchView
    }

    private func makeTabsView() -> FlexibleHeightTabView {
        let view = FlexibleHeightTabView(titles: ["Teams", "AllMatch"], style: .segmented)
        // Add content view
        view.contentAt(index: 0)?.addArrangedSubview(allTeamView)
        view.contentAt(index: 1)?.addArrangedSubview(allMatchView)
        return view
    }

    private func makeTeamListView() -> AllTeamView {
        let view = AllTeamView()
        view.delegate = self
        return view
    }

    private func makeAllMatchView() -> MatchesView {
        let view = MatchesView()
        view.viewModel = viewModel
        view.delegate = self
        return view
    }
}

extension HomeViewController: AllTeamViewDelegate {
    func allTeamView(_ view: AllTeamView, didSelect team: FootballTeam) {
        let detailViewController: TeamDetailViewControler = TeamDetailViewControler(team: team)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension HomeViewController: MatchesViewDelegate {
    func matchesView(_ view: MatchesView, didOpen highlights: String?) {
        presentPlayerViewControler(with: highlights)
    }
}

extension UIViewController {
    func presentPlayerViewControler(with videoUrl: String?) {
        guard let videoUrl = URL(string: videoUrl ?? "") else {
            return
        }
        let playerItem = AVPlayerItem(url: videoUrl)
        let player: AVPlayer? = AVPlayer(playerItem: playerItem)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        present(playerViewController, animated: true) {
            player?.play()
        }
    }
}

extension UISearchTextField {
    var texPublisher: AnyPublisher<String, Error> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map(\.object)
            .map { $0 as! UITextField }
            .map(\.text)
            .compactMap { $0 }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
