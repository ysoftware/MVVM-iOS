//
//  Array.swift
//  MVVM
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public class ArrayViewModel<M, VM:ViewModel<M>, Q:Query> {

	init(query:Q) {
		self.query = query
	}

	// MARK: - Public properties

	public private(set) var reachedEnd = false
	public fileprivate(set) var isLoading = false
	public weak var delegate:ArrayViewModelDelegate?
	public var query:Q

	// MARK: - Private properties

	private var list:[VM] = []
	private var shouldClearData = false

	// MARK: - Public methods for override

	public func fetchData(_ query:Q, _ block: @escaping ([M])->Void) {
		fatalError("override ArrayViewModel.fetchData(_:_:)")
	}

	// MARK: - Public methods

	public func loadMore() {
		guard !isLoading && !reachedEnd else { return }
		isLoading = true
		fetchData(query) { items in
			if items.count < self.query.size {
				self.reachedEnd = true
			}
			self.manageItems(items)
			self.isLoading = false
			self.didUpdateData()
		}
		query.advance()
	}

	public func reloadData() {
		resetData()
		loadMore()
	}

	public var numberOfItems:Int {
		return list.count
	}

	public func item(at index:Int,
					 shouldLoadMore:Bool = false) -> VM {
		if shouldLoadMore, index == list.count - 1 {
			loadMore()
		}
		return list[index]
	}

	// MARK: - Private methods

	private func didUpdateData() {
		guard let delegate = delegate else { return }
		DispatchQueue.main.async {
			delegate.didUpdateData(self)
			delegate.didUpdateData()
		}
	}

	public func manageItems(_ newItems:[M]) {
		if shouldClearData {
			list = []
			shouldClearData = false
		}
		if newItems.isEmpty {
			reachedEnd = true
		}
		else {
			list.append(contentsOf: newItems.map { VM($0) })
		}
	}

	private func resetData() {
		shouldClearData = true
		query.resetPosition()
		reachedEnd = false
	}
}
