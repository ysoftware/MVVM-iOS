//
//  Delegate.swift
//  MVVM
//
//  Created by ysoftware on 07.07.2018.
//

import Foundation

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

	/// Элемент был перемещён.
	///
	/// - Parameters:
	///   - startIndex: начальная позиция элемента.
	///   - endIndex: новая позиция элемента (после перемещения).
	///
	///	Рекомендуется вызов
	/// ```
	/// .moveRow(
	///   at: IndexPath(row: index,
	///                 section: 0),
	///   to: IndexPath(row: newIndex,
	///               section: 0))
	func didMoveElement(at startIndex:Int, to endIndex:Int)

	/// ArrayViewModel изменил статус.
	///
	/// - Parameter state: новый статус процессов внутри array view model.
	func didChangeState(to state:ArrayViewModelState)
}

public extension ArrayViewModelDelegate {

	func didDeleteElements(at indexes:[Int]) {}

	func didUpdateElements(at indexes:[Int]) {}

	func didAddElements(at indexes:[Int]) {}

	func didMoveElement(at startIndex:Int, to endIndex:Int) {}

	func didUpdateData() {}

	func didChangeState(to state:ArrayViewModelState) {}
}
