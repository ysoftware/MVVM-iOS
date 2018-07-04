//
//  Single.swift
//  MVVM
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Основной класс для управления данными.
public class ViewModel<M> {

	public required init(_ model:M) {
		self.model = model
	}

	// MARK: - Public properties

	typealias Model = M

	public weak var delegate:ViewModelDelegate?

	public let model:M!

	// MARK: - Public methods

	public func didUpdateData() {
		guard let delegate = delegate else { return }
		delegate.didUpdateData(self)
	}
}
