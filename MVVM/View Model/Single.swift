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

	public init() { }

	public required init(_ model:M, arrayDelegate:ViewModelDelegate? = nil) {
		self.arrayDelegate = arrayDelegate
		self.model = model
	}

	// MARK: - Public properties

	/// Может быть nil если данные загружаются внутри view model.
	public var model:M?

	/// Объект, получающий события view model.
	public weak var delegate:ViewModelDelegate? {
		didSet {
			if model != nil {
				DispatchQueue.main.async {
					self.delegate?.didUpdateData(self)
				}
			}
		}
	}

	// MARK: - Inner properties

	/// Специальный делегат для array view model.
	public weak var arrayDelegate:ViewModelDelegate?

	// MARK: - Public methods

	public func notifyUpdated() {
		DispatchQueue.main.async {
			self.delegate?.didUpdateData(self)
			self.arrayDelegate?.didUpdateData(self)
		}
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
