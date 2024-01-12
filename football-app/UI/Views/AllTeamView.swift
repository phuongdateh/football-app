//
//  AllTeamView.swift
//  football-app
//
//  Created by James on 11/01/2024.
//

import Foundation
import UIKit

final class AllTeamView: UIStackView {
    enum AllTeamSection: Int {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<AllTeamSection, FootballTeam>

    private lazy var collectionView: UICollectionView = makeCollectionView()
    private lazy var dataSource: DataSource = makeDataSource()

    weak var delegate: AllTeamViewDelegate?

    init() {
        super.init(frame: .zero)
        axis = .vertical
        addArrangedSubview(collectionView)
        configurationCollectionView()
    }

    func configurationCollectionView() {
        collectionView.registerCell(TeamCollectionViewCell.self)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    func makeGridLayoutSection() -> NSCollectionLayoutSection {
        // Each item will dynamically adjust its size based on content:
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .estimated(150), // Adjust the estimated width based on your content
            heightDimension: .estimated(150) // Adjust the estimated height based on your content
        ))

        // Each group will take up the entire available width:
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(150) // Adjust the estimated height based on your content
            ),
            subitem: item,
            count: 2
        )

        return NSCollectionLayoutSection(group: group)
    }

    func makeListLayoutSection() -> NSCollectionLayoutSection {
            // Here, each item completely fills its parent group:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(1)
            ))
        
            // Each group then contains just a single item, and fills
            // the entire available width, while defining a fixed
            // height of 50 points:
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(50)
                ),
                subitems: [item]
            )
            return NSCollectionLayoutSection(group: group)
        }

    func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch AllTeamSection(rawValue: sectionIndex) {
            case .main:
                return self?.makeListLayoutSection()
            default:
                return nil
            }
        }
    }

    func makeCollectionView() -> UICollectionView {
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionViewLayout())
    }

    private func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell: TeamCollectionViewCell = collectionView.dequeueCell(indexPath: indexPath)
            cell.nameLabel.text = itemIdentifier.name?.replacingOccurrences(of: "Team", with: "")
            cell.logoImageView.load(from: itemIdentifier.logo ?? "")
            return cell
        }
    }

    func teamsDidLoad(_ teamList: [FootballTeam]) {
        var snapshot = NSDiffableDataSourceSnapshot<AllTeamSection, FootballTeam>()
        snapshot.appendSections([.main])
        snapshot.appendItems(teamList)
        dataSource.apply(snapshot)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AllTeamView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let team = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        delegate?.allTeamView(self, didSelect: team)
    }
}

protocol AllTeamViewDelegate: AnyObject {
    func allTeamView(_ view: AllTeamView, didSelect team: FootballTeam)
}
