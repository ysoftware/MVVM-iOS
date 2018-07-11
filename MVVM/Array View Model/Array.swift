//
//  Array.swift
//  MVVM
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Основной класс для управления списками данных с возможной пагинацией.
/// Для простого списка без пагинации, есть упрощённый сабкласс `SimpleArrayViewModel`.
open class ArrayViewModel<M, VM:ViewModel<M>, Q:Query> {

	/// Стандартный инициализатор.
	public init() {}

	// MARK: - Public properties

	/// Объект получающий сигналы об изменении данных.
	public weak var delegate:ArrayViewModelDelegate? {
		didSet {
			if !array.isEmpty {
				delegate?.didUpdateData()
			}
		}
	}

	/// Если запрос nil, пагинация отключена.
	public var query:Q?

	/// Список view model.
	public private(set) var array:[VM] = []

	/// Текущий статус процессов внутри array view model.
	public private(set) var state:ArrayViewModelState = .initial {
		didSet {
			DispatchQueue.main.async {
				self.delegate?.didChangeState(to: self.state)
			}
		}
	}

	/// Нужно ли очистить данные при следующей загрузке.
	/// Защищает от крэша.
	private var shouldClearData = false

	// MARK: - Public methods for override

	/// Метод для загрузки данных из базы данных. Обязателен к оверрайду.
	///
	/// - Parameters:
	///   - query: объект query для настройки запроса к базе.
	///   - block: блок, в который необходимо отправить загруженные объекты.
	///	  - data: список объектов класса модели, полученный из базы данных.
	///	  - error: ошибка при загрузке данных.
	open func fetchData(_ query:Q?, _ block: @escaping (_ data:[M], _ error:Error?)->Void) {
		fatalError("override ArrayViewModel.fetchData(_:_:)")
	}

	// MARK: - Public methods

	/// Загрузить больше элементов.
	public func loadMore() {
		switch state {
		case .loading, .loadingMore, .ready(true): return
		default: break
		}

		state.setLoading()
		
		fetchData(query) { items, error in
			if let error = error {
				return self.state.setError(error)
			}

			let reachedEnd = self.query == nil
				|| !self.query!.isPaginationEnabled
				|| items.count < self.query!.size

			self.manageItems(items)
			self.state.setReady(reachedEnd)
		}
		query?.advance()
	}

	/// Сбросить все данные и загрузить с начала списка.
	public func reloadData() {
		resetData()
		loadMore()
	}

	/// Сбросить все данные.
	public func clearData() {
		resetData()
		manageItems([])
	}

	/// Принять новые загруженные элементы в список.
	///
	/// - Parameter newItems: новые элементы.
	public func manageItems(_ newItems:[M]) {
		DispatchQueue.main.async {
			if self.shouldClearData {
				self.array = []
				self.shouldClearData = false
				self.delegate?.didUpdateData()
			}

			let isFirstLoad = self.array.isEmpty
			self.array.append(contentsOf: newItems.map { VM($0) })
			self.array.forEach { $0.delegate = self }

			// notify
			if isFirstLoad {
				self.delegate?.didUpdateData()
			}
			else {
				let endIndex = self.array.endIndex
				let startIndex = endIndex - newItems.count
				let indexes = (startIndex..<endIndex).map { $0 }
				self.delegate?.didAddElements(at: indexes)
			}
		}
	}

	// MARK: - Private methods

	/// Очистить данные и сбросить информацию о загрузке.
	private func resetData() {
		state.reset()
		shouldClearData = true
		query?.resetPosition()
	}

	// MARK: - Operations

	/// Добвить элемент в список.
	///
	/// - Parameter element: новый объект viewModel.
	public func append(_ element:VM) {
		DispatchQueue.main.async {
			self.array.append(element)
			self.delegate?.didAddElements(at: [self.array.endIndex-1])
		}
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
	///    Полезно при заполнении ячейки table или collectionView.
	/// - Returns: элемент viewModel из списка.
	public func item(at index:Int,
					 shouldLoadMore:Bool = false) -> VM {
		if shouldLoadMore, index == array.count - 1 {
			loadMore()
		}
		return array[index]
	}

	/// Уведомить arrayViewModel об обновлении отдельного элемента.
	/// Элемент должен находиться в списке.
	///
	/// - Parameter viewModel: обновлённый view model.
	public func notifyUpdated(_ viewModel: VM) {
		guard let index = array.index(of: viewModel) else { return }
		DispatchQueue.main.async {
			self.delegate?.didUpdateElements(at: [index])
		}
	}

	/// Удалить элемент из списка.
	///
	/// - Parameter index: позиция элемента.
	public func delete(at index:Int) {
		// обновление данных и вызов делегата
		// должны быть на одном потоке, иначе может произойти
		// ошибка tableView inconsistency
		DispatchQueue.main.async {
			self.array.remove(at: index)
			self.delegate?.didDeleteElements(at: [index])
		}
	}

	/// Переместить элемент.
	///
	/// - Parameters:
	///   - index: первоначальная позиция элемента.
	///   - newIndex: новая позиция элемента (после перемещения)
	public func move(at index:Int, to newIndex:Int) {
		guard array.endIndex > index, index >= 0 else { return }
		DispatchQueue.main.async {
			let newIndex = min(newIndex, self.array.endIndex-1)
			self.array.insert(self.array.remove(at: index), at: newIndex)
			self.delegate?.didMoveElement(at: index, to: newIndex)
		}
	}
}
