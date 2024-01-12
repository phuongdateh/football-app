//
//  AllMatchView.swift
//  football-app
//
//  Created by James on 10/01/2024.
//

import Foundation
import UIKit

protocol MatchesViewDelegate: AnyObject {
    func matchesView(_ view: MatchesView, didOpen highlights: String?)
}

final class MatchesView: UIStackView {
    typealias DataSource = UICollectionViewDiffableDataSource<AllMatchSection, FootballMatch>

    private lazy var collectionView: UICollectionView = makeCollectionView()
    private lazy var dataSource: DataSource = makeDataSource()

    weak var delegate: MatchesViewDelegate?

    init() {
        super.init(frame: .zero)
        axis = .vertical
        addArrangedSubview(collectionView)
        configurationCollectionView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup CollectionView
    enum AllMatchSection: Int {
        case main
    }

    private func configurationCollectionView() {
        collectionView.registerCell(MatchCollectionViewCell.self)
        collectionView.dataSource = dataSource
    }

    private func makeListLayoutSection() -> NSCollectionLayoutSection {
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(1)
            ))

            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(50)
                ),
                subitems: [item]
            )
            return NSCollectionLayoutSection(group: group)
        }

    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            self?.makeListLayoutSection()
        }
    }

    func makeCollectionView() -> UICollectionView {
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionViewLayout())
    }

    private func makeDataSource() -> DataSource {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            let cell: MatchCollectionViewCell = collectionView.dequeueCell(indexPath: indexPath)
            cell.delegate = self
            cell.update(itemIdentifier)
            self?.viewModel?.getLogo(of: itemIdentifier.away)
                .sinkToResult { result in
                    switch result {
                    case .success(let url):
                        cell.awayTeamView.logoImageView.load(from: url ?? "")
                    default:
                        break
                    }
                }
                .cancel()
            self?.viewModel?.getLogo(of: itemIdentifier.home)
                .sinkToResult { result in
                    switch result {
                    case .success(let url):
                        cell.homeTeamView.logoImageView.load(from: url ?? "")
                    default:
                        break
                    }
                }
                .cancel()
            return cell
        }
    }

    private let cancelBag: CancelBag = CancelBag()

    // Update Data
    func matchesDidLoad(_ matches: [FootballMatch]) {
        var snapshot = NSDiffableDataSourceSnapshot<AllMatchSection, FootballMatch>()
        snapshot.appendSections([.main])
        snapshot.appendItems(matches)
        dataSource.apply(snapshot)
    }

    // Injected viewModel to support get Logo for each team
    var viewModel: MatchesViewModel?
}

extension MatchesView: MatchCollectionViewCellDelegate {
    func matchCollectionViewCell(_ cell: MatchCollectionViewCell, didSelect highlights: String?) {
        delegate?.matchesView(self, didOpen: highlights)
    }
}
