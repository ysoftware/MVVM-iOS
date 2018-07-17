//
//  Delegate.swift
//  MVVM
//
//  Created by ysoftware on 07.07.2018.
//

import UIKit

public protocol ArrayViewModelDelegate: class {

	/// ArrayViewModel изменил статус.
	///
	/// - Parameter state: новый статус процессов внутри array view model.
	func didChangeState(to state:ArrayViewModelState)

	/// ArrayViewModel обновил данные.
	///
	/// - Parameters:
	///   - arrayViewModel: объект arrayViewModel.
	///   - update: информация об обновлении данных.
	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								 _ update: Update) where Q:Query
}

public extension ArrayViewModelDelegate {

	func didChangeState(to state:ArrayViewModelState) {}
}

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
