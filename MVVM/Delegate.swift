//
//  Delegate.swift
//  MVVM
//
//  Created by ysoftware on 07.07.2018.
//

import Foundation

// MARK: - Single

public protocol ViewModelDelegate: class {

	func didUpdateData<M>(_ viewModel: ViewModel<M>)
}

public extension ViewModelDelegate {
	func didUpdateData<M>(_ viewModel: ViewModel<M>) {}
}

// MARK: - Array

public protocol ArrayViewModelDelegate: class {

	/// Список был полностью или частично обновлен.
	/// Рекомендуется для обновления UI или вызова
	/// ```
	/// .reloadData()
	func didUpdateData()

	/// Элемент был добавлен в список.
	///
	/// - Parameter indexes: индексы элементов
	///
	///	Рекомендуется вызов
	/// ```
	/// .insertRows(at:
	///  indexes.map {
	///   IndexPath(row: $0,
	///             section: 0)
	///  },
	/// with: .automatic)
	func didAddElements(at indexes:[Int])

	/// Элемент был удалён из списка.
	///
	/// - Parameter indexes: индексы элементов
	///
	///	Рекомендуется вызов
	/// ```
	/// .deleteRows(at:
	///  indexes.map {
	///   IndexPath(row: $0,
	///             section: 0)
	///  },
	/// with: .automatic)
	func didDeleteElements(at indexes:[Int])

	/// Элемент был удалён из списка.
	///
	/// - Parameter indexes: индексы элементов
	///
	///	Рекомендуется вызов
	/// ```
	/// .reloadRows(at:
	///  indexes.map {
	///   IndexPath(row: $0,
	///             section: 0)
	///  },
	/// with: .automatic)
	func didUpdateElements(at indexes:[Int])
}

public extension ArrayViewModelDelegate {

	func didDeleteElements(at indexes:[Int]) {}

	func didUpdateElements(at indexes:[Int]) {}

	func didAddElements(at indexes:[Int]) {}

	func didUpdateData() {}
}
