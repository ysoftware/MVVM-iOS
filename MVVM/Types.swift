//
//  Types.swift
//  MVVM
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public protocol Query {

	var size:Int { get }

	func resetPosition()

	func advance()
}

public protocol ArrayViewModelDelegate: class {
	
	func didUpdateData<M, VM:ViewModel<M>, Q:Query>(_ arrayViewModel: ArrayViewModel<M, VM, Q>)

	func didUpdateData()
}

extension ArrayViewModelDelegate {

	func didUpdateData<M, VM:ViewModel<M>, Q:Query>(_ arrayViewModel: ArrayViewModel<M, VM, Q>) {}

	func didUpdateData() {}
}

public protocol ViewModelDelegate: class {
	
	func didUpdateData<M>(_ viewModel: ViewModel<M>)
}
