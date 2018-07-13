//
//  Update.swift
//  MVVM
//
//  Created by ysoftware on 13.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public enum Update {

	/// Список был полностью или частично обновлен.
	/// Рекомендуется для обновления UI или вызова
	/// ```
	/// .reloadData()
	case reload

	/// Элементы были добавлены в список.
	///
	/// indexes: индексы элементов
	///
	///	Рекомендуется вызов
	/// ```
	/// .insertRows(at:
	///  indexes.map {
	///   IndexPath(row: $0,
	///             section: 0)
	///  },
	/// with: .automatic)
	case append(indexes:[Int])

	/// Элементы были удалены из списка.
	///
	/// indexes: индексы элементов
	///
	///	Рекомендуется вызов
	/// ```
	/// .deleteRows(at:
	///  indexes.map {
	///   IndexPath(row: $0,
	///             section: 0)
	///  },
	/// with: .automatic)
	case delete(indexes:[Int])

	/// Элементы были удалены из списка.
	///
	/// indexes: индексы элементов
	///
	///	Рекомендуется вызов
	/// ```
	/// .reloadRows(at:
	///  indexes.map {
	///   IndexPath(row: $0,
	///             section: 0)
	///  },
	/// with: .automatic)
	case update(indexes:[Int])

	/// Элемент был перемещён.
	///
	/// startIndex: начальная позиция элемента.
	///
	/// endIndex: новая позиция элемента (после перемещения).
	///
	///	Рекомендуется вызов
	/// ```
	/// .moveRow(
	///   at: IndexPath(row: index,
	///                 section: 0),
	///   to: IndexPath(row: newIndex,
	///               section: 0))
	case move(startIndex:Int, endIndex:Int)
}
