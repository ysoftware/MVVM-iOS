//
//  State.swift
//  MVVM
//
//  Created by ysoftware on 11.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public enum ArrayViewModelState {

	case
	initial,					// начало инициализации
	loading, 					// загрузка с начала
	error(Error),				// ошибка - данных нет
	ready(reachedEnd:Bool),		// успех
	loadingMore,				// идет загрузка пагинации
	paginationError(Error)		// ошибка пагинации - есть старые данные
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

extension ArrayViewModelState {

	mutating func reset() {
		self = .initial
	}

	mutating func setReady(_ reachedEnd:Bool) {
		self = .ready(reachedEnd: reachedEnd)
	}

	mutating func setLoading() {
		if self == .initial {
			self = .loading
		}
		else {
			self = .loadingMore
		}
	}

	mutating func setError(_ error:Error) {
		if self == .loading {
			self = .error(error)
		}
		else {
			self = .paginationError(error)
		}
	}
}
