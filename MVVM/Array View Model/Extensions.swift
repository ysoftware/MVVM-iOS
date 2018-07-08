//
//  ArrayExtensions.swift
//  MVVM
//
//  Created by ysoftware on 07.07.2018.
//

import Foundation

extension ArrayViewModel: ViewModelDelegate {

	public func didUpdateData<M>(_ viewModel: ViewModel<M>) {
		notifyUpdated(viewModel as! VM)
	}
}

extension ArrayViewModel: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "ArrayViewModel with \(array.count) element(s)"
	}
}
