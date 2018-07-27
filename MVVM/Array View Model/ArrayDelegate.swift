//
//  Delegate.swift
//  MVVM
//
//  Created by ysoftware on 07.07.2018.
//

import Foundation

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
