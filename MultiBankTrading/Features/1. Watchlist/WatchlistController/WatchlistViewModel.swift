//
//  WatchlistViewModel.swift
//  MultiBankTrading
//
//  Created by Vijendra.Yadav on 05/04/26.
//

import Foundation


protocol WatchlistViewModelDelegate: AnyObject {
	func didInsertStocks(at indices: [Int])
	func didUpdateStocks(at indices: [Int])
	func didReloadAllStocks()
	func didChangeLiveState(isLive: Bool)
}

final class WatchlistViewModel {
	
	weak var delegate: WatchlistViewModelDelegate?
	
	private(set) var stocks: [BroadcastModel] = []
	private(set) var filteredStocks: [BroadcastModel] = []
	private(set) var isLive = false
	private(set) var currentSort: SortOption = .none
	
	private var searchText = ""
	private var timer: Timer?
	/// Symbols used for price ticks; must stay in sync with the selected watchlist.
	private var activeScriptTokens: [String] = WatchlistPickerOption.myWatchlist.getSymbols
	
	// MARK: - Connection
	
	func startFeed() {
		WebSocketManager.shared.connect(delegate: self)
	}
	
	func stopFeed() {
		stopTimer()
		WebSocketManager.shared.disconnect()
	}
	
	func toggleFeed() {
		isLive ? stopFeed() : startFeed()
	}
	
	// MARK: - Sort
	
	func applySort(_ option: SortOption) {
		currentSort = option
		applySortAndFilter()
	}
	
	// MARK: - Search / Filter
	
	func search(query: String) {
		searchText = query
		applySortAndFilter()
	}
    
	func setRandomPriceForWatchlistSelection(option: WatchlistPickerOption) {
		activeScriptTokens = option.getSymbols
		stopTimer()
		stocks = []
		filteredStocks = []
		applySortAndFilter()
		WebSocketManager.shared.disconnect()
		startFeed()
		// First send happens in `didReceive(.connected)` — socket is not open yet here.
	}
	
	/// Latest row data for a symbol (matches watchlist / filtered list).
	func broadcastModel(forTokenId tokenId: String) -> BroadcastModel? {
		if let fromFiltered = filteredStocks.first(where: { $0.tokenId == tokenId }) {
			return fromFiltered
		}
		return stocks.first { $0.tokenId == tokenId }
	}
	
	// MARK: - Private
	
	private func applySortAndFilter() {
		if searchText.isEmpty {
			filteredStocks = stocks
		} else {
			let query = searchText.lowercased()
			filteredStocks = stocks.filter {
				$0.tokenId.lowercased().contains(query)
				|| $0.name.lowercased().contains(query)
				|| $0.description.lowercased().contains(query)
			}
		}
		
		switch currentSort {
			case .none:
				break
			case .priceHighToLow:
				filteredStocks.sort { $0.latestPrice > $1.latestPrice }
			case .priceLowToHigh:
				filteredStocks.sort { $0.latestPrice < $1.latestPrice }
			case .changeHighToLow:
				filteredStocks.sort { $0.percentChange > $1.percentChange }
			case .changeLowToHigh:
				filteredStocks.sort { $0.percentChange < $1.percentChange }
		}
		
		delegate?.didReloadAllStocks()
	}
	
	private func updateStocks(with models: [BroadcastModel]) {
		let hasSortOrFilter = currentSort != .none || !searchText.isEmpty
		var updatedIndices: [Int] = []
		var insertedIndices: [Int] = []
		
		for model in models {
			if let idx = stocks.firstIndex(where: { $0.tokenId == model.tokenId }) {
				stocks[idx] = model
				if !hasSortOrFilter {
					updatedIndices.append(idx)
				}
			} else {
				stocks.append(model)
				if !hasSortOrFilter {
					insertedIndices.append(stocks.count - 1)
				}
			}
		}
		
		if hasSortOrFilter {
			applySortAndFilter()
			return
		}
		
		filteredStocks = stocks
		
		if !insertedIndices.isEmpty {
			delegate?.didInsertStocks(at: insertedIndices)
		}
		if !updatedIndices.isEmpty {
			delegate?.didUpdateStocks(at: updatedIndices)
		}
	}
	
	private func setLive(_ live: Bool) {
		isLive = live
		delegate?.didChangeLiveState(isLive: live)
	}
	
	// MARK: - Timer
	private func startTimerIfNeeded() {
		guard timer == nil else { return }
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
			guard let self else { return }
			WebSocketManager.shared.sendRandomPrice(scripts: self.activeScriptTokens)
		}
	}
	
	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
	
	deinit {
		stopTimer()
	}
	
}

// MARK: - BroadcastSenderDelegate

extension WatchlistViewModel: BroadcastSenderDelegate {
	
	func didReceive(event: WebSocketEvent) {
		switch event {
			case .connected:
				setLive(true)
				startTimerIfNeeded()
//				WebSocketManager.shared.sendRandomPrice(scripts: activeScriptTokens)
				
			case .disconnected:
				setLive(false)
				stopTimer()
				
			case .priceUpdate(let models):
				updateStocks(with: models)
				
			case .message:
				break
				
			case .error:
				setLive(false)
				stopTimer()
		}
	}
	
}
