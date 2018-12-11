//
//  Collection.swift
//  MVVM
//
//  Created by ysoftware on 11/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

extension ArrayViewModel: Collection {

	public typealias Index = Int

	public typealias Element = VM

	public var startIndex: Index {
		return 0
	}

	public var endIndex: Index {
		return numberOfItems - 1
	}

	public subscript(index:Index) -> Element {
		return item(at: index)
	}

	public func index(after i: Int) -> Int {
		return i + 1
	}
}
