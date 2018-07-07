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

extension ArrayViewModel: Equatable {
	public static func == (lhs: ArrayViewModel<M, VM, Q>,
						   rhs: ArrayViewModel<M, VM, Q>) -> Bool {
		return lhs.array == rhs.array
	}
}

extension ArrayViewModel: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "ArrayViewModel with \(array.count) element(s)"
	}
}
