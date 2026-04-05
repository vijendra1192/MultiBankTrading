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
