//
//  Reusable.swift
//  Loaders
//
//  Created by Dariusz Grzeszczak on 19/02/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

import UIKit

public struct Reusable<View> {
    let nibName: String
    let reuseIdentifier: String
    let bundle: () -> Bundle

    var nib: UINib {
        return UINib(nibName: nibName, bundle: bundle())
    }

    public func instantiate() -> View {
        guard let view =  nib.instantiate(withOwner: nil, options: nil)[0] as? View else {
            fatalError("Could not load view \(nibName)")
        }

        return view
    }
}

extension Reusable where View: UITableViewCell {

    public func register(on tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }

    public func dequeue(on tableView: UITableView, for indexPath: IndexPath) -> View {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? View else {
            fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)")
        }
        return cell
    }
}

extension Reusable where View: UICollectionViewCell {

    public func register(on collectionView: UICollectionView) {
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }

    public func dequeue(on collectionView: UICollectionView, for indexPath: IndexPath) -> View {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? View else {
            fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)")
        }
        return cell
    }
}

public enum ReusableCollectionViewKind: RawRepresentable {

    case header, footer

    public init?(rawValue: String) {
        switch rawValue {
        case UICollectionView.elementKindSectionHeader: self = .header
        case UICollectionView.elementKindSectionFooter: self = .footer
        default: return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

extension Reusable where View: UICollectionReusableView {

    public func register(on collectionView: UICollectionView, forSupplementaryViewOfKind kind: ReusableCollectionViewKind) {
        collectionView.register(nib, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: reuseIdentifier)
    }

    public func dequeue(on collectionView: UICollectionView, kind: ReusableCollectionViewKind, for indexPath: IndexPath) -> View {

        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind.rawValue,
                                                                         withReuseIdentifier: reuseIdentifier,
                                                                         for: indexPath) as? View else {

                                                                            fatalError("Could not dequeue supplementary view of kind \(kind) with identifier: \(reuseIdentifier)")
        }

        return view
    }
}
