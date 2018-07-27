//
//  Simple.swift
//  MVVM
//
//  Created by ysoftware on 07.07.2018.
//

import Foundation
import Result

/// Основной класс для управления списками данных без пагинации.
open class SimpleArrayViewModel<M, VM:ViewModel<M>>: ArrayViewModel<M, VM, SimpleQuery> {

	final override public func fetchData(_ query: SimpleQuery?,
										 _ block: @escaping (_ result:Result<[M], AnyError>) -> Void) {
		fetchData(block)
	}

	/// Метод для загрузки данных из базы данных. Обязателен к оверрайду.
	///
	/// - Parameters:
	///   - block: блок, в который необходимо отправить загруженные объекты.
	///	  - data: список объектов класса модели, полученный из базы данных.
	///	  - error: ошибка при загрузке данных.
	open func fetchData(_ block: @escaping (_ result:Result<[M], AnyError>)->Void) {
		fatalError("override ArrayViewModel.fetchData(_:)")
	}
}

/// Query-заглушка, используемая в SimpleArrayViewModel.
public class SimpleQuery:Query {

	public var isPaginationEnabled = false

	public func resetPosition() {}
}
