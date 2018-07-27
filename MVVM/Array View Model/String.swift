//
//  String.swift
//  MVVM
//
//  Created by ysoftware on 27.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

open class StringArrayViewModel: SimpleArrayViewModel<String, ViewModel<String>> {

	private var temp:[String]!

	public init(with array:[String]) {
		super.init()
		temp = array
		reloadData()
	}

	final override func fetchData(_ block: @escaping (Result<[String]>) -> Void) {
		block(Result.data(temp!))
		temp = nil
	}

	// MARK: - Methods

	public func appendString(_ model:String) {
		append(ViewModel(model))
	}
}
