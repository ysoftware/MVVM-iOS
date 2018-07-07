//
//  Types.swift
//  MVVM
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public protocol Query {

	var isPaginationEnabled:Bool { get }

	var size: Int { get }

	func resetPosition()

	func advance()
}

public class SimpleQuery:Query {

	public var isPaginationEnabled = false

	public var size: Int = 0

	public func resetPosition() {}

	public func advance() {}
}
