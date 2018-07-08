//
//  Classes.swift
//  MVVMTests
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation
@testable import MVVM

let data = [TestModel(0), TestModel(1), TestModel(2), TestModel(3),  TestModel(4),  TestModel(5)]

class TestQuery:Query {

	var offset:Int { return page*size }

	var page = 0

	var size = 2

	var isPaginationEnabled = true

	func advance() {
		page += 1
	}

	func resetPosition() {
		page = 0
	}
}

class TestModel:NSObject {
	
	var number:Int

	init(_ n:Int) {
		number = n
	}
}

class TestArrayViewModelDelegate: ArrayViewModelDelegate {

	var didUpdate = false
	var didUpdateElement = false
	var didAddElement = false
	var didMoveElement = false
	var didDeleteElement = false

	func didUpdateData() {
		didUpdate = true
	}

	func didAddElements(at indexes: [Int]) {
		didAddElement = true
	}

	func didDeleteElements(at indexes: [Int]) {
		didDeleteElement = true
	}

	func didUpdateElements(at indexes: [Int]) {
		didUpdateElement = true 
	}

	func didMoveElement(at startIndex: Int, to endIndex: Int) {
		didMoveElement = true
	}
}

class TestViewModel:ViewModel<TestModel> {

	// properties
	var number:Int { return model?.number ?? 0 }

	func setNumber(_ number:Int) {
		model?.number = number
		notifyUpdated()
	}
}

class TestArrayViewModel: ArrayViewModel<TestModel, TestViewModel, TestQuery> {

	override func fetchData(_ query: TestQuery?, _ block: @escaping ([TestModel])->Void) {
		if let query = query, query.isPaginationEnabled {
			let startIndex = data.startIndex.advanced(by: query.offset)
			let endIndex = min(startIndex.advanced(by: query.size), data.endIndex)
			block(Array(data[startIndex..<endIndex]))
		}
		else {
			block(data)
		}
	}

}
