//
//  Types.swift
//  MVVM
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Настройка запроса. Может использоваться для передачи данных о фильтрации,
/// сортировке и других параметрах запроса при обращении в базу данных.
public protocol Query {

	/// Использовать ли пагинацию.
	/// Стандартное значение - `true`.
	var isPaginationEnabled: Bool { get }

	/// Размер загружаемого при пагинации списка.
	/// Стандартное значение - 20.
	var size: UInt { get }

	/// Сбросить позицию пагинации.
	func resetPosition()

	/// Продвинуться вперёд по списку.
	/// ```
	/// // Например,
	/// func advance() {
	///     page += 1
	/// }
	/// ```
	/// Если ваш query нуждается в информации, полученной из сетевого запроса,
	/// Пропустите advance() и вручную обновляйте query внутри метода ArrayViewModel.fetchData.
	func advance()
}

public extension Query {

	var isPaginationEnabled: Bool { return true }

	var size: UInt { return 20 }

	func advance() {}
}
