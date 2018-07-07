//
//  Types.swift
//  MVVM
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public protocol Query {

	var isPaginationEnabled: Bool { get }

	var size: Int { get }

	func resetPosition()

	func advance()
}

public extension Query {

	var isPaginationEnabled: Bool { return true }

	var size: Int { return 20 }
}

public class SimpleQuery:Query {

	public var isPaginationEnabled = false

	public var size: Int = 0

	public func resetPosition() {}

	public func advance() {}
}
