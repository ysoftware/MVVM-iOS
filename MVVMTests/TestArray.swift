//
//  TestArray.swift
//  MVVMTests
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import XCTest

class TestsArrayViewModel: XCTestCase {

	func testDelegate() {

		// set up
		let delegate = TestArrayViewModelDelegate()
		let array = TestArrayViewModel()
		array.query = TestQuery()
		array.delegate = delegate

		// fetch data
		array.reloadData()

		// check delegate method called
		let expectation = XCTestExpectation(description: "did not call delegate method")
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
			if delegate.didUpdate {
				expectation.fulfill()
			}
		}
		wait(for: [expectation], timeout: 0.2)
	}

	func testArrayNoPagination() {

		// test with query nil
		let array = TestArrayViewModel()

		array.reloadData()
		XCTAssertEqual(array.numberOfItems, 6, "not all elements loaded")

		array.loadMore()
		XCTAssertEqual(array.numberOfItems, 6, "somehow loaded more elements")

		let item1 = array.item(at: 3)
		XCTAssertEqual(item1.number, 3, "wrong element")

		// test with query but isPaginationEnabled = false
		let query = TestQuery()
		query.isPaginationEnabled = false
		array.query = query

		array.reloadData()
		XCTAssertEqual(array.numberOfItems, 6, "not all elements loaded")

		array.loadMore()
		XCTAssertEqual(array.numberOfItems, 6, "somehow loaded more elements")

		let item2 = array.item(at: 3)
		XCTAssertEqual(item2.number, 3, "wrong element")
	}

	func testArrayPagination() {

		// test initial load
		let query = TestQuery()
		let array = TestArrayViewModel()
		array.query = query
		array.reloadData()
		let count1 = array.numberOfItems
		XCTAssertEqual(array.numberOfItems, query.size, "elements did not load")

		// test load more
		array.loadMore()
		let count2 = array.numberOfItems
		XCTAssertGreaterThan(count2, count1, "more elements did not load")

		// test auto load more
		let item3 = array.item(at: 3, shouldLoadMore: true)
		let count3 = array.numberOfItems
		XCTAssertGreaterThan(count3, count2, "more elements did not auto load")

		// test element at index
		let item5 = array.item(at: 5, shouldLoadMore: true)
		XCTAssertEqual(item3.number, 3, "wrong element")
		XCTAssertEqual(item5.number, 5, "wrong element")

		// test reached end
		XCTAssertTrue(array.reachedEnd, "did not reach end?")

		// test reached end not trying to load more
		let count4 = array.numberOfItems
		array.loadMore()
		XCTAssertEqual(array.numberOfItems, count4, "loaded more data after reached end")

		// test reset data
		array.reloadData()
		XCTAssertEqual(array.numberOfItems, query.size, "did not reset data")
	}
}
