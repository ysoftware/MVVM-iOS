//
//  State.swift
//  MVVM
//
//  Created by ysoftware on 11.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Статус процессов внутри array view model.
public enum ArrayViewModelState {

	// MARK: - Cases

	/// Пустой view model.
	case initial

	/// Идёт первоначальная загрузка.
	case loading

	/// Ошибка при первоначальной загрузке.
	case error(error:Error)

	/// Данные загружены.
	case ready(reachedEnd:Bool)

	/// Идёт подгрузка данных.
	case loadingMore

	/// Ошибка при загрузке второго или последующего блока данных при пагинации.
	case paginationError(error:Error)

	// MARK: - Methods

	/// Установить `.initial`
	mutating func reset() {
		self = .initial
	}

	/// Установить `.ready`
	///
	/// - Parameter reachedEnd: достигли ли мы конца списка.
	mutating func setReady(_ reachedEnd:Bool) {
		self = .ready(reachedEnd: reachedEnd)
	}

	/// Установить `.loading` / `.loadingMore` в зависимости от текущего статуса.
	mutating func setLoading() {
		if self == .initial {
			self = .loading
		}
		else {
			self = .loadingMore
		}
	}

	/// Установить `.error` / `.paginationError` в зависимости от текущего статуса.
	mutating func setError(_ error:Error) {
		if self == .loading {
			self = .error(error: error)
		}
		else {
			self = .paginationError(error: error)
		}
	}
}

extension ArrayViewModelState: Equatable {

	public static func == (lhs: ArrayViewModelState, rhs: ArrayViewModelState) -> Bool {
		switch (lhs, rhs) {
		case (.initial, .initial): return true
		case (.loading, .loading): return true
		case (.loadingMore, .loadingMore): return true
		case (.ready(let value), .ready(let value2)) : return value == value2
		default: return false
		}
	}
}
