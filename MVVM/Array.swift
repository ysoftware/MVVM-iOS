//
//  Array.swift
//  MVVM
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Основной класс для управления списками данных.
public class ArrayViewModel<M, VM:ViewModel<M>, Q:Query> {

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
	private var list:[VM] = []

	/// Нужно ли очистить данные при следующей загрузке.
	/// Защищает от крэша.
	private var shouldClearData = false

	// MARK: - Public methods for override

	/// Метод для загрузки данных из базы данных. Обязателен к оверрайду.
	///
	/// - Parameters:
	///   - query: объект query для настройки запроса к базе.
	///   - block: блок, в который необходимо отправить загруженные объекты.
	public func fetchData(_ query:Q?, _ block: @escaping ([M])->Void) {
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
			self.didUpdateData()
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
		return list.count
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
		if shouldLoadMore, index == list.count - 1 {
			loadMore()
		}
		return list[index]
	}

	// MARK: - Private methods

	/// Вызвать delegate.didUpdateData на main thread.
	private func didUpdateData() {
		guard let delegate = delegate else { return }
		DispatchQueue.main.async {
			delegate.didUpdateData(self)
			delegate.didUpdateData()
		}
	}

	/// Принять новые загруженные элементы в список.
	///
	/// - Parameter newItems: новые элементы.
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

	/// Очистить данные и сбросить информацию о загрузке.
	private func resetData() {
		shouldClearData = true
		query?.resetPosition()
		reachedEnd = false
	}
}
