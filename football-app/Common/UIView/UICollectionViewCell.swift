//
//  UICollectionViewCell.swift
//  football-app
//
//  Created by James on 10/01/2024.
//

import Foundation
import UIKit

extension UICollectionView {
    func registerCell<CellType: UICollectionViewCell>(_: CellType.Type) {
        register(CellType.self, forCellWithReuseIdentifier: String(describing: CellType.self))
    }

    func dequeueCell<CellType: UICollectionViewCell>(indexPath: IndexPath) -> CellType {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CellType.self), for: indexPath) as? CellType else {
            return .init()
        }
        return cell
    }
}

extension UITableView {
    func registerCell<CellType: UITableViewCell>(_: CellType.Type) {
        register(CellType.self, forCellReuseIdentifier: String(describing: CellType.self))
    }

    func dequeueCell<CellType: UITableViewCell>(indexPath: IndexPath) -> CellType {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: CellType.self), for: indexPath) as? CellType else {
            return .init()
        }
        return cell
    }
}
