//
//  String.swift
//  MVVM
//
//  Created by ysoftware on 27.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation
import Result

open class StringArrayViewModel: SimpleArrayViewModel<String, ViewModel<String>> {

	public init(with array:[String]) {
		super.init()
		setData(array.map { ViewModel($0) })
		reloadData()
	}

	final override public func fetchData(_ block: @escaping (Result<[String], AnyError>) -> Void) {
		block(.success([]))
	}

	// MARK: - Methods

	public func appendString(_ model:String) {
		append(ViewModel(model))
	}
}
