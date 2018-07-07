//
//  Single.swift
//  MVVM
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Основной класс для управления данными.
open class ViewModel<M:Equatable> {

	public required init(_ model:M) {
		self.model = model
	}

	// MARK: - Public properties

	typealias Model = M

	public weak var delegate:ViewModelDelegate?

	/// Может быть nil если данные загружаются внутри view model.
	public var model:M?

	// MARK: - Public methods

	public func didUpdateData() {
		guard let delegate = delegate else { return }
		delegate.didUpdateData(self)
	}
}

extension ViewModel: Equatable {

	public static func == (lhs: ViewModel<M>, rhs: ViewModel<M>) -> Bool {
		return lhs.model == rhs.model
	}
}

extension ViewModel: CustomDebugStringConvertible {

	public var debugDescription: String {
		return model.debugDescription
	}
}
