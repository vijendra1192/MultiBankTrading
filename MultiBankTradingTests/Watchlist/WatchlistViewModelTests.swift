//
//  WatchlistViewModelTests.swift
//  MultiBankTradingTests
//
//  Tests `WatchlistViewModel` with a mock socket (no real WebSocket / RunLoop network).
//  Technique: dependency injection via `WatchlistSocketServing`, spy delegate, Arrange–Act–Assert.
//

import XCTest
@testable import MultiBankTrading

// MARK: - Test doubles

private final class MockWatchlistSocket: WatchlistSocketServing {
    
    private(set) var connectCallCount = 0
	private(set) var disconnectCallCount = 0
	private(set) var sendRandomPriceScripts: [[String]] = []
	private(set) weak var lastDelegate: BroadcastSenderDelegate?

	func connect(delegate: BroadcastSenderDelegate) {
		connectCallCount += 1
		lastDelegate = delegate
	}

	func disconnect() {
		disconnectCallCount += 1
	}

	func sendRandomPrice(scripts: [String]) {
		sendRandomPriceScripts.append(scripts)
	}

	func simulateConnected() {
		lastDelegate?.didReceive(event: .connected)
	}

	func simulateDisconnected(code: Int = 0) {
		lastDelegate?.didReceive(event: .disconnected(code: code))
	}

	func simulatePriceUpdate(_ models: [BroadcastModel]) {
		lastDelegate?.didReceive(event: .priceUpdate(models))
	}

	func simulateError() {
		lastDelegate?.didReceive(event: .error("test"))
	}

}

// MARK: - WatchlistViewModelDelegate

private final class MockWatchlistViewModelDelegate: WatchlistViewModelDelegate {

	var reloadAllCount = 0
	var insertCalls: [[Int]] = []
	var updateCalls: [[Int]] = []
	private(set) var liveStates: [Bool] = []

	func didInsertStocks(at indices: [Int]) {
		insertCalls.append(indices)
	}

	func didUpdateStocks(at indices: [Int]) {
		updateCalls.append(indices)
	}

	func didReloadAllStocks() {
		reloadAllCount += 1
	}

	func didChangeLiveState(isLive: Bool) {
		liveStates.append(isLive)
	}
}

// MARK: - Helpers

private func makeModel(tokenId: String, price: Double = 10, pct: Double = 1) -> BroadcastModel {
	var m = BroadcastModel()
	m.tokenId = tokenId
	m.name = tokenId
	m.latestPrice = price
	m.percentChange = pct
	m.priceDirection = .up
	return m
}

// MARK: - Tests

final class WatchlistViewModelTests: XCTestCase {

	private var socket: MockWatchlistSocket!
	private var delegate: MockWatchlistViewModelDelegate!
	private var sut: WatchlistViewModel!

	override func setUp() {
		super.setUp()
		socket = MockWatchlistSocket()
		delegate = MockWatchlistViewModelDelegate()
		sut = WatchlistViewModel(socket: socket)
		sut.delegate = delegate
	}

	override func tearDown() {
		sut = nil
		delegate = nil
		socket = nil
		super.tearDown()
	}

	// MARK: - Connection

	func testStartFeed_requestsSocketConnect() {
		sut.startFeed()
		XCTAssertEqual(socket.connectCallCount, 1)
		XCTAssert(socket.lastDelegate === sut)
	}

	func testStopFeed_disconnectsSocket() {
		sut.startFeed()
		sut.stopFeed()
		XCTAssertEqual(socket.disconnectCallCount, 1)
	}

	func testSimulateConnected_setsLiveAndNotifiesDelegate() {
		sut.startFeed()
		socket.simulateConnected()
		XCTAssertTrue(sut.isLive)
		XCTAssertEqual(delegate.liveStates.last, true)
	}

	func testSimulateDisconnected_setsNotLive() {
		sut.startFeed()
		socket.simulateConnected()
		socket.simulateDisconnected()
		XCTAssertFalse(sut.isLive)
		XCTAssertEqual(delegate.liveStates.last, false)
	}

	func testSimulateError_setsNotLiveAndStopsTimerPath() {
		sut.startFeed()
		socket.simulateConnected()
		socket.simulateError()
		XCTAssertFalse(sut.isLive)
	}

	// MARK: - Price updates

	func testPriceUpdate_appendsNewSymbol_emitsInsert() {
		sut.startFeed()
		socket.simulateConnected()
		let m = makeModel(tokenId: "SYM1")
		socket.simulatePriceUpdate([m])
		XCTAssertEqual(sut.stocks.count, 1)
		XCTAssertEqual(sut.stocks.first?.tokenId, "SYM1")
		XCTAssertFalse(delegate.insertCalls.isEmpty)
		XCTAssertEqual(delegate.insertCalls.last, [0])
		// No sort/filter: incremental path does not call `didReloadAllStocks` (table inserts rows instead).
		XCTAssertEqual(delegate.reloadAllCount, 0)
	}

	func testPriceUpdate_sameTokenWithoutSort_emitsUpdate() {
		sut.startFeed()
		socket.simulateConnected()
		socket.simulatePriceUpdate([makeModel(tokenId: "SYM1", price: 10)])
		delegate.insertCalls.removeAll()
		delegate.updateCalls.removeAll()
		socket.simulatePriceUpdate([makeModel(tokenId: "SYM1", price: 11)])
		XCTAssertEqual(sut.stocks.count, 1)
		XCTAssertFalse(delegate.updateCalls.isEmpty)
		XCTAssertEqual(delegate.updateCalls.last, [0])
	}

	func testPriceUpdate_withActiveSort_usesReloadInsteadOfIncremental() {
		sut.applySort(.priceHighToLow)
		sut.startFeed()
		socket.simulateConnected()
		delegate.reloadAllCount = 0
		delegate.insertCalls.removeAll()
		socket.simulatePriceUpdate([makeModel(tokenId: "A", price: 5)])
		XCTAssertTrue(delegate.insertCalls.isEmpty, "Sorted mode should not emit incremental inserts")
		XCTAssertGreaterThan(delegate.reloadAllCount, 0)
	}

	// MARK: - Sort / search / lookup

	func testApplySort_updatesCurrentSortAndReloads() {
		sut.applySort(.priceLowToHigh)
		XCTAssertEqual(sut.currentSort, .priceLowToHigh)
		XCTAssertGreaterThan(delegate.reloadAllCount, 0)
	}

	func testSearch_triggersFilteredReload() {
		sut.search(query: "aa")
		XCTAssertGreaterThan(delegate.reloadAllCount, 0)
	}

	func testBroadcastModel_prefersFilteredRow() {
		sut.startFeed()
		socket.simulateConnected()
		socket.simulatePriceUpdate([makeModel(tokenId: "X", price: 1)])
		sut.search(query: "X")
		let row = sut.broadcastModel(forTokenId: "X")
		XCTAssertEqual(row?.tokenId, "X")
	}

	// MARK: - Watchlist switch

	func testSetRandomPriceForWatchlistSelection_disconnectsAndReconnects() {
		sut.startFeed()
		socket.simulateConnected()
		let disconnectBefore = socket.disconnectCallCount
		let connectBefore = socket.connectCallCount
		sut.setRandomPriceForWatchlistSelection(option: .tech)
		XCTAssertEqual(socket.disconnectCallCount, disconnectBefore + 1)
		XCTAssertEqual(socket.connectCallCount, connectBefore + 1)
		XCTAssertTrue(sut.stocks.isEmpty)
		XCTAssertTrue(sut.filteredStocks.isEmpty)
	}
}
