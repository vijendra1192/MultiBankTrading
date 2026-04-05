//
//  WebSocketManager.swift
//  MultiBankStockPrice
//
//  Created by Vijendra.Yadav on 01/04/26.
//

import Foundation

final class WebSocketManager: NSObject, WebSocketManagerProtocol, URLSessionDelegate, URLSessionWebSocketDelegate {
	
	static let shared = WebSocketManager()
	private override init() {}
	
	private var webSocketTask: URLSessionWebSocketTask?
	private lazy var session: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
	private weak var delegate: BroadcastSenderDelegate?
	private var isManualDisconnect = false
	private var isConnected = false
	private var scripts: [String] = [""]
	private var pingTimer: Timer?
	
	func connect(delegate: BroadcastSenderDelegate) {
		self.delegate = delegate
		connect()
	}
	
	func connect() {
		isManualDisconnect = false
		isConnected = false
		webSocketTask?.cancel(with: .goingAway, reason: nil)
		let endpoint = Constants.webSocketURLString
		let url = URL(string: endpoint)
		guard let url else { return }
		webSocketTask = session.webSocketTask(with: url)
		
		webSocketTask?.resume()
		receiveMessage()
	}
	
	func disconnect() {
		isManualDisconnect = true
		isConnected = false
		stopPing()
		webSocketTask?.cancel(with: .goingAway, reason: nil)
		webSocketTask = nil
	}
	
	func reConnect() {
		guard !isManualDisconnect else { return }
		
		DispatchQueue.main.asyncAfter(deadline: .now() + Constants.reconnectDelay) { [weak self] in
			self?.connect()
		}
	}
	
	func receiveMessage() {
		webSocketTask?.receive { [weak self] result in
			switch result {
			case .success(let success):
				switch success {
				case .string(let string):
					if let jsonData = string.data(using: .utf8),
					   let models = try? JSONDecoder().decode([BroadcastModel].self, from: jsonData) {
						self?.delegate?.didReceive(event: .priceUpdate(models))
					} else {
						self?.delegate?.didReceive(event: .message(string))
					}
				case .data(let data):
					if let models = try? JSONDecoder().decode([BroadcastModel].self, from: data) {
						self?.delegate?.didReceive(event: .priceUpdate(models))
					} else if let text = String(data: data, encoding: .utf8) {
						self?.delegate?.didReceive(event: .message(text))
					}
				@unknown default:
					break
				}
			case .failure(let error):
				self?.delegate?.didReceive(event: .error(error.localizedDescription))
				self?.isConnected = false
				self?.reConnect()
				return
			}
			self?.receiveMessage()
		}
	}
	
	func sendRandomPrice(scripts: [String]) {
		self.scripts = scripts
		guard isConnected else {
			if webSocketTask == nil {
				connect()
			}
			return
		}
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			let model = PriceGenerator.generateBroadcastModel(scripts: scripts)
			guard let data = try? JSONEncoder().encode(model),
				  let jsonString = String(data: data, encoding: .utf8) else { return }
			let wsMessage = URLSessionWebSocketTask.Message.string(jsonString)
			
			self?.webSocketTask?.send(wsMessage) { error in
				if let error = error {
					self?.delegate?.didReceive(event: .error(error.localizedDescription))
					self?.isConnected = false
					self?.reConnect()
				}
			}
		}
	}

	func urlSession(_ session: URLSession,
					webSocketTask: URLSessionWebSocketTask,
					didOpenWithProtocol protocol: String?) {
		isConnected = true
		startPing()
		delegate?.didReceive(event: .connected)
	}
	
	private func startPing() {
		stopPing()
		pingTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
			self?.webSocketTask?.sendPing { error in
				if let error {
					print("Ping failed:", error.localizedDescription)
					self?.isConnected = false
					self?.reConnect()
				}
			}
		}
	}
	
	private func stopPing() {
		pingTimer?.invalidate()
		pingTimer = nil
	}

	func urlSession(_ session: URLSession,
					webSocketTask: URLSessionWebSocketTask,
					didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
					reason: Data?) {
		isConnected = false
		delegate?.didReceive(event: .disconnected(code: closeCode.rawValue))
		if !isManualDisconnect {
			reConnect()
		}
	}
	
}
