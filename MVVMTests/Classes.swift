//
//  Classes.swift
//  MVVMTests
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation
import Result
@testable import MVVM

let data = [TestModel(0), TestModel(1), TestModel(2), TestModel(3),  TestModel(4),  TestModel(5)]

final class TestQuery:Query {

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

final class TestModel:NSObject {
	
	var number:Int

	init(_ n:Int) {
		number = n
	}
}

final class TestArrayViewModelDelegate: ArrayViewModelDelegate {

	var didUpdate = false
	var didUpdateElement = false
	var didAddElement = false
	var didMoveElement = false
	var didDeleteElement = false

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>, _ update: Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
			
			switch update {
			case .append(_):
				didAddElement = true
			case .delete(_):
				didDeleteElement = true
			case .move(_):
				didMoveElement = true
			case .reload:
				didUpdateElement = true
			case .update(_):
				didUpdate = true

			}
	}
}

final class TestViewModel:ViewModel<TestModel> {

	// properties
	var number:Int { return model?.number ?? 0 }

	func setNumber(_ number:Int) {
		model?.number = number
		notifyUpdated()
	}
}

final class TestError: LocalizedError {
	var errorDescription: String? { return "пример ошибки" }
}

final class TestArrayViewModel: ArrayViewModel<TestModel, TestViewModel, TestQuery> {

	override func fetchData(_ query: TestQuery?, _ block: @escaping (Result<[TestModel], AnyError>)->Void) {
		if let query = query, query.isPaginationEnabled {
			let startIndex = data.startIndex.advanced(by: query.offset)
			let endIndex = min(startIndex.advanced(by: query.size), data.endIndex)
			block(.success(Array(data[startIndex..<endIndex])))
		}
		else {
			block(.failure(AnyError(TestError())))
		}
	}
}
