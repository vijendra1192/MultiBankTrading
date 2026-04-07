//
//  AppConstants.swift
//  MultiBankStockPrice
//
//  Created by Vijendra.Yadav on 01/04/26.
//

import Foundation

enum AppConstants {
	static let webSocketURLString: String = "wss://ws.postman-echo.com/raw"
	static let reconnectDelay = 2.0
    
    enum NibFileNames {
        static let stockDetailsController = "StockDetailsViewController"
        static let sortAndFilterController = "SortFilterViewController"
        
    }
    
    enum ButtonTitle {
        static let buy = "BUY"
        static let sell = "SELL"
        static let stopFeed = "Stop feed"
        static let startFeed = "Start feed"
    }
    
    enum MessageShow {
        static let featureComing = "Feature coming soon..."
    }
}
