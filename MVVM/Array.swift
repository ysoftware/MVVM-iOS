//
//  Array.swift
//  MVVM
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Основной класс для управления списками данных.
open class ArrayViewModel<M, VM:ViewModel<M>, Q:Query> {

	/// Default initializer
	public init() {}

	// MARK: - Public properties

	/// Загружен ли последний элемент в список.
	public private(set) var reachedEnd = false

	/// Идёт ли процесс загрузки данных.
	public fileprivate(set) var isLoading = false

	/// Объект получающий сигналы об изменении данных.
	public weak var delegate:ArrayViewModelDelegate?

	/// Если запрос nil, пагинация отключена.
	public var query:Q?

	// MARK: - Private properties

	/// Список view model.
	public private(set) var array:[VM] = []

	/// Нужно ли очистить данные при следующей загрузке.
	/// Защищает от крэша.
	private var shouldClearData = false

	// MARK: - Public methods for override

	/// Метод для загрузки данных из базы данных. Обязателен к оверрайду.
	///
	/// - Parameters:
	///   - query: объект query для настройки запроса к базе.
	///   - block: блок, в который необходимо отправить загруженные объекты.
	open func fetchData(_ query:Q?, _ block: @escaping ([M])->Void) {
		fatalError("override ArrayViewModel.fetchData(_:_:)")
	}

	// MARK: - Public methods

	/// Загрузить больше элементов.
	public func loadMore() {
		guard !isLoading && !reachedEnd else { return }
		isLoading = true
		
		fetchData(query) { items in
			if self.query == nil
				|| !self.query!.isPaginationEnabled
				|| items.count < self.query!.size {
				self.reachedEnd = true
			}
			self.manageItems(items)
			self.isLoading = false
		}
		query?.advance()
	}

	/// Сбросить все данные и загрузить с начала списка.
	public func reloadData() {
		resetData()
		loadMore()
	}

	/// Текущее количество элементов в списке.
	public var numberOfItems:Int {
		return array.count
	}

	/// Получить элемент по индексу.
	///
	/// - Parameters:
	///   - index: индекс элемента.
	///   - shouldLoadMore: должна ли запуститься пагинация при запросе последнего элемента.
	///    Полезно при заполнении ячейки table или collection view.
	/// - Returns: элемент view model из списка.
	public func item(at index:Int,
					 shouldLoadMore:Bool = false) -> VM {
		if shouldLoadMore, index == array.count - 1 {
			loadMore()
		}
		return array[index]
	}

	// MARK: - Change model

	public func append(_ element:VM) {
		DispatchQueue.main.async {
			self.array.append(element)
			self.didAddElements(at: [self.array.endIndex - 1])
		}
	}

	public func delete(at index:Int) {
		DispatchQueue.main.async {
			self.array.remove(at: index)
			self.didDeleteElements(at: [index])
		}
	}

	public func notifyUpdated(_ viewModel: VM) {
		guard let index = array.index(of: viewModel) else { return }
		DispatchQueue.main.async {
			self.didUpdateElements(at: [index])
		}
	}

	/// Принять новые загруженные элементы в список.
	///
	/// - Parameter newItems: новые элементы.
	public func manageItems(_ newItems:[M]) {
		DispatchQueue.main.async {
			if self.shouldClearData {
				self.array = []
				self.shouldClearData = false
			}
			if newItems.isEmpty {
				self.reachedEnd = true
			}
			else {
				self.array.append(contentsOf: newItems.map { VM($0) })
				self.array.forEach { $0.delegate = self }

				// notify
				let endIndex = self.array.endIndex
				let startIndex = endIndex - newItems.count
				let indexes = (startIndex..<endIndex).map { $0 }
				self.didAddElements(at: indexes)
			}
		}
	}

	// MARK: - Private methods

	/// Очистить данные и сбросить информацию о загрузке.
	private func resetData() {
		shouldClearData = true
		query?.resetPosition()
		reachedEnd = false
	}

	// MARK: - Delegate calls

	private func didAddElements(at indexes:[Int]) {
		guard let delegate = delegate, !indexes.isEmpty else { return }
		delegate.didAddElements(at: indexes)
		delegate.didUpdateData()
	}

	private func didUpdateElements(at indexes:[Int]) {
		guard let delegate = delegate, !indexes.isEmpty else { return }
		delegate.didUpdateElements(at: indexes)
		delegate.didUpdateData()
	}

	private func didDeleteElements(at indexes:[Int]) {
		guard let delegate = delegate, !indexes.isEmpty else { return }
		delegate.didDeleteElements(at: indexes)
		delegate.didUpdateData()
	}

}

extension ArrayViewModel: ViewModelDelegate {

	public func didUpdateData<M>(_ viewModel: ViewModel<M>) {
		notifyUpdated(viewModel as! VM)
	}
}

extension ArrayViewModel: Equatable {
	public static func == (lhs: ArrayViewModel<M, VM, Q>,
						   rhs: ArrayViewModel<M, VM, Q>) -> Bool {
		return lhs.array == rhs.array
	}
}

extension ArrayViewModel: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "ArrayViewModel with \(array.count) element(s)"
	}
}

