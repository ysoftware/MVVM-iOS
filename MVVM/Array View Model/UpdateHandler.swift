//
//  UpdateHandler.swift
//  MVVM
//
//  Created by ysoftware on 27.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

#if canImport(UIKit)
import UIKit

/// Простейший делегат для array view model для управления tableView / collectionView.
public class ArrayViewModelUpdateHandler {

	private init() { }

	private weak var tableView:UITableView?
	private weak var collectionView:UICollectionView?

	public var section = 0

	public init(with tableView:UITableView) {
		self.tableView = tableView
	}

	public init(with collectionView:UICollectionView) {
		self.collectionView = collectionView
	}

	public func handle(_ update: Update) {

		switch update {
		case .reload:
			tableView?.reloadData()
			collectionView?.reloadData()

		case .append(let indexes):
			let indexPaths = indexes.map { IndexPath(row: $0, section: section) }
			tableView?.insertRows(at: indexPaths, with: .automatic)
			collectionView?.insertItems(at: indexPaths)

		case .update(let indexes):
			let indexPaths = indexes.map { IndexPath(row: $0, section: section) }
			tableView?.reloadRows(at: indexPaths, with: .automatic)
			collectionView?.reloadItems(at: indexPaths)

		case .delete(let indexes):
			let indexPaths = indexes.map { IndexPath(row: $0, section: section) }
			tableView?.deleteRows(at: indexPaths, with: .automatic)
			collectionView?.deleteItems(at: indexPaths)

		case .move(_, _):
			break
		}
	}
}
#endif
