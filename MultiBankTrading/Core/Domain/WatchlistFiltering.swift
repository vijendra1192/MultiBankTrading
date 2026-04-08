//
//  WatchlistFiltering.swift
//  MultiBankTrading
//

import Foundation

/// Pure functions for search + sort over `BroadcastModel` rows.
struct WatchlistFiltering {

	/// Case-insensitive substring match on token and name.
	static func getFilterData(_ stocks: [BroadcastModel], searchText: String) -> [BroadcastModel] {
		let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmed.isEmpty else { return stocks }
		let query = trimmed.lowercased()
		return stocks.filter {
			$0.tokenId.lowercased().contains(query) || $0.name.lowercased().contains(query)
		}
	}

    /// sorting based on stock price and price change
	static func getSortData(_ stocks: [BroadcastModel], by option: SortOption) -> [BroadcastModel] {
		var result = stocks
		switch option {
			case .none:
				break
			case .priceHighToLow:
				result.sort { $0.latestPrice > $1.latestPrice }
			case .priceLowToHigh:
				result.sort { $0.latestPrice < $1.latestPrice }
			case .changeHighToLow:
				result.sort { $0.priceChange > $1.priceChange }
			case .changeLowToHigh:
				result.sort { $0.priceChange < $1.priceChange }
		}
		return result
	}

	/// Applies filter then sort
	static func apply(searchText: String, sort: SortOption, to stocks: [BroadcastModel]) -> [BroadcastModel] {
		let filtered = getFilterData(stocks, searchText: searchText)
		return getSortData(filtered, by: sort)
	}
}
