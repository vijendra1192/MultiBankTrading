//
//  PriceGenerator.swift
//  MultiBankStockPrice
//
//  Created by Vijendra.Yadav on 01/04/26.
//

import Foundation

final class PriceGenerator {
	
	static func generateBroadcastModel(scripts: [String]) -> [BroadcastModel] {
		let symbols: [StockSymbol]
		
		if scripts.isEmpty {
			symbols = StockSymbol.allCases
		} else {
			symbols = scripts.compactMap {
				let symbol = StockSymbol(rawValue: $0)
				if symbol == nil {
					print("Invalid symbol: \($0)")
				}
				return symbol
			}
		}
		return createBroadcastModel(symbols: symbols)
	}
	
	static func createBroadcastModel(symbols: [StockSymbol]) -> [BroadcastModel] {
		return symbols.map { symbol in
			let base = symbol.openPrice
			let newPrice = Double.random(in: base * 0.95 ... base * 1.05)
			let change = newPrice - base
			let percent = (change / base) * 100
			var direction: PriceDirection = .neutral
			if change == 0 {
				direction = .neutral
			} else if change > 0 {
				direction = .up
			} else if change < 0 {
				direction = .down
			}
			
			return BroadcastModel(
				tokenId: symbol.rawValue,
				name: symbol.rawValue,
				country: "US",
				openPrice: base,
				latestPrice: newPrice,
				priceChange: change,
				percentChange: percent,
				description: symbol.description,
				priceDirection: direction
			)
		}
	}
	
}
