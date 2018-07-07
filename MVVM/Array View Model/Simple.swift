//
//  Simple.swift
//  MVVM
//
//  Created by ysoftware on 07.07.2018.
//

import Foundation

/// Основной класс для управления списками данных без пагинации.
open class SimpleArrayViewModel<M, VM:ViewModel<M>>: ArrayViewModel<M, VM, SimpleQuery> {

	final override public func fetchData(_ query: SimpleQuery?,
										 _ block: @escaping ([M]) -> Void) {
		fetchData(block)
	}

	open func fetchData(_ block: @escaping ([M])->Void) {
		fatalError("override ArrayViewModel.fetchData(_:)")
	}
}
