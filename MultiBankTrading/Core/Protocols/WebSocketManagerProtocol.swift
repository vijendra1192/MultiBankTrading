//
//  WebSocketManagerProtocol.swift
//  MultiBankStockPrice
//
//  Created by Vijendra.Yadav on 01/04/26.
//

import Foundation

enum WebSocketEvent {
	case connected
	case disconnected(code: Int)
	case priceUpdate([BroadcastModel])
	case message(String)
	case error(String)
}

protocol BroadcastSenderDelegate: AnyObject {
	func didReceive(event: WebSocketEvent)
}

protocol WebSocketManagerProtocol {
	func connect()
	func disconnect()
	func receiveMessage()
	func reConnect()
}

/// Socket surface used by `WatchlistViewModel` — inject a mock in unit tests (no real WebSocket).
protocol WatchlistSocketServing: AnyObject {
	func connect(delegate: BroadcastSenderDelegate)
	func disconnect()
	func sendRandomPrice(scripts: [String])
}

extension WebSocketManager: WatchlistSocketServing {}
