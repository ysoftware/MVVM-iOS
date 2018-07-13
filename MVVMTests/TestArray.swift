//
//  TestArray.swift
//  MVVMTests
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import XCTest
@testable import MVVM

final class TestsArrayViewModel: XCTestCase {

	func testDelegate() {

		// set up
		let delegate = TestArrayViewModelDelegate()
		let array = TestArrayViewModel()
		array.query = TestQuery()
		array.delegate = delegate

		// fetch data
		array.reloadData()

		// check delegate method called
		self.async {
			XCTAssertTrue(delegate.didUpdate, "did not call delegate method")
		}
	}

	func testEditing() {

		// create without pagination
		let array = TestArrayViewModel()
		let delegate = TestArrayViewModelDelegate()
		array.delegate = delegate

		array.reloadData()
		self.async {
			XCTAssertEqual(array.numberOfItems, 6, "not all elements loaded")

			// delete element
			array.delete(at: 0)
			self.async {
				XCTAssertEqual(array.numberOfItems, 5, "element was not deleted")
				XCTAssertTrue(delegate.didDeleteElement, "delegate was not called")

				// add new element
				let number7 = 7
				array.append(TestViewModel(TestModel(number7)))
				self.async {
					XCTAssertEqual(array.numberOfItems, 6,
								   "element was not added")
					XCTAssertEqual(array.item(at: 5).number, number7,
								   "element was added to wrong position")
					XCTAssertTrue(delegate.didAddElement,
								  "delegate was not called")

					// move element
					array.move(at: 5, to: 0)
					self.async {
						XCTAssertEqual(array.item(at: 0).number, number7,
									   "element was added to wrong position")
						XCTAssertTrue(delegate.didMoveElement,
									  "delegate was not called")

						// update element
						let number0 = 0
						array.item(at: 0).setNumber(0)
						self.async {
							XCTAssertEqual(array.item(at: 0).number, number0,
										   "element was added to wrong position")
							XCTAssertTrue(delegate.didUpdateElement,
										  "delegate was not called")
						}}}}}
	}

	func testArrayNoPagination() {

		// test with query nil
		let array = TestArrayViewModel()

		array.reloadData()
		self.async {
			XCTAssertEqual(array.numberOfItems, 6, "not all elements loaded")

			array.loadMore()
			self.async {
				XCTAssertEqual(array.numberOfItems, 6, "somehow loaded more elements")

				let item1 = array.item(at: 3)
				XCTAssertEqual(item1.number, 3, "wrong element")

				// test with query but isPaginationEnabled = false
				let query = TestQuery()
				query.isPaginationEnabled = false
				array.query = query

				array.reloadData()
				self.async {
					XCTAssertEqual(array.numberOfItems, 6, "not all elements loaded")

					array.loadMore()
					self.async {
						XCTAssertEqual(array.numberOfItems, 6, "somehow loaded more elements")

						let item2 = array.item(at: 3)
						XCTAssertEqual(item2.number, 3, "wrong element")
					}}}}
	}

	func testArrayPagination() {

		// test initial load
		let query = TestQuery()
		let array = TestArrayViewModel()
		array.query = query

		array.reloadData()
		self.async {
			let count1 = array.numberOfItems
			XCTAssertEqual(array.numberOfItems, query.size,
						   "elements did not load")

			// test load more
			array.loadMore()
			self.async {
				let count2 = array.numberOfItems
				XCTAssertGreaterThan(count2, count1,
									 "more elements did not load")

				// test auto load more
				let item3 = array.item(at: 3, shouldLoadMore: true)
				self.async {
					let count3 = array.numberOfItems
					XCTAssertGreaterThan(count3, count2,
										 "more elements did not auto load")

					// test element at index
					let item5 = array.item(at: 5, shouldLoadMore: true)
					self.async {
						XCTAssertEqual(item3.number, 3, "wrong element")
						XCTAssertEqual(item5.number, 5, "wrong element")

						// test reached end
						XCTAssertTrue(array.state == ArrayViewModelState.ready(reachedEnd:true),
									  "did not reach end?")

						// test reached end not trying to load more
						let count4 = array.numberOfItems
						array.loadMore()
						self.async {
							XCTAssertEqual(array.numberOfItems, count4,
										   "loaded more data after reached end")

							// test reset data
							array.reloadData()
							self.async {
								XCTAssertEqual(array.numberOfItems, query.size,
											   "did not reset data")
							}}}}}}
	}
}

extension TestsArrayViewModel {
	func async(_ block: @escaping ()->Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
			block()
		}
	}
}
