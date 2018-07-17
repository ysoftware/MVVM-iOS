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

	/// Может быть nil если данные загружаются внутри view model.
	public var model:M?

	/// Объект, получающий события view model.
	public weak var delegate:ViewModelDelegate? {
		didSet {
			if model != nil {
				delegate?.didUpdateData(self)
			}
		}
	}

	// MARK: - Inner properties

	/// Специальный делегат для array view model.
	weak var arrayDelegate:ViewModelDelegate? {
		didSet {
			if model != nil {
				arrayDelegate?.didUpdateData(self)
			}
		}
	}

	// MARK: - Public methods

	public func notifyUpdated() {
		delegate?.didUpdateData(self)
		arrayDelegate?.didUpdateData(self)
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
