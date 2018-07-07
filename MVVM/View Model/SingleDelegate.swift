//
//  Delegate.swift
//  MVVM
//
//  Created by ysoftware on 07.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public protocol ViewModelDelegate: class {

	func didUpdateData<M>(_ viewModel: ViewModel<M>)
}

public extension ViewModelDelegate {
	
	func didUpdateData<M>(_ viewModel: ViewModel<M>) {}
}
