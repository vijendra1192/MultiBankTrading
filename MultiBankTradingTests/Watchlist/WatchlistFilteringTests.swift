//
//  WatchlistFilteringTests.swift
//  MultiBankTradingTests
//
//  Tests pure domain logic: search (token / name / description) and sort orders.
//  Technique: Arrange–Act–Assert with small `BroadcastModel` fixtures (no UI, no network).
//

import XCTest
@testable import MultiBankTrading

final class WatchlistFilteringTests: XCTestCase {

	// MARK: - Fixtures

	private func model(
		tokenId: String,
		name: String = "",
		description: String = "",
		latestPrice: Double = 0,
		percentChange: Double = 0
	) -> BroadcastModel {
		var m = BroadcastModel()
		m.tokenId = tokenId
		m.name = name
		m.description = description
		m.latestPrice = latestPrice
		m.percentChange = percentChange
		return m
	}

	// MARK: - Filter

	func testFilter_emptyQuery_returnsAllRows() {
		let rows = [
			model(tokenId: "A"),
			model(tokenId: "B"),
		]
		let out = WatchlistFiltering.getFilterData(rows, searchText: "")
		XCTAssertEqual(out.map(\.tokenId), ["A", "B"])
	}

	func testFilter_whitespaceOnlyQuery_treatedAsNoFilter() {
		let rows = [model(tokenId: "Z")]
		let out = WatchlistFiltering.getFilterData(rows, searchText: "   \n\t  ")
		XCTAssertEqual(out.count, 1)
		XCTAssertEqual(out.first?.tokenId, "Z")
	}

	func testFilter_matchesTokenCaseInsensitive() {
		let rows = [
			model(tokenId: "AAPL.OQ"),
			model(tokenId: "MSFT.OQ"),
		]
		let out = WatchlistFiltering.getFilterData(rows, searchText: "aapl")
		XCTAssertEqual(out.map(\.tokenId), ["AAPL.OQ"])
	}

	func testFilter_matchesNameAndDescription() {
		let rows = [
			model(tokenId: "X", name: "Apple Inc", description: ""),
			model(tokenId: "Y", name: "Other", description: "Produces phones"),
		]
		XCTAssertEqual(WatchlistFiltering.getFilterData(rows, searchText: "apple").count, 1)
		XCTAssertEqual(WatchlistFiltering.getFilterData(rows, searchText: "other").first?.tokenId, "Y")
	}

	// MARK: - Sort

	func testSort_priceHighToLow() {
		let rows = [
			model(tokenId: "a", latestPrice: 1),
			model(tokenId: "b", latestPrice: 99),
			model(tokenId: "c", latestPrice: 50),
		]
		let out = WatchlistFiltering.getSortData(rows, by: .priceHighToLow)
		XCTAssertEqual(out.map(\.tokenId), ["b", "c", "a"])
	}

	func testSort_changeLowToHigh() {
		let rows = [
			model(tokenId: "a", latestPrice: -2),
			model(tokenId: "b", latestPrice: 5),
			model(tokenId: "c", latestPrice: 0),
		]
		let out = WatchlistFiltering.getSortData(rows, by: .priceLowToHigh)
		XCTAssertEqual(out.map(\.tokenId), ["a", "c", "b"])
	}

	func testSort_none_preservesOrder() {
		let rows = [model(tokenId: "z"), model(tokenId: "y")]
		let out = WatchlistFiltering.getSortData(rows, by: .none)
		XCTAssertEqual(out.map(\.tokenId), ["z", "y"])
	}

	// MARK: - Combined (matches view model pipeline)

	func testApply_filterThenSort() {
		let rows = [
			model(tokenId: "AAA", latestPrice: 10, percentChange: 1),
			model(tokenId: "AAB", latestPrice: 30, percentChange: 2),
			model(tokenId: "BBB", latestPrice: 20, percentChange: 3),
		]
		let out = WatchlistFiltering.apply(searchText: "AA", sort: .priceHighToLow, to: rows)
		XCTAssertEqual(out.map(\.tokenId), ["AAB", "AAA"])
	}
}
