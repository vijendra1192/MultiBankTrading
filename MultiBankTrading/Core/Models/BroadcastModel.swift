//
//  BroadcastModel.swift
//  MultiBankStockPrice
//
//  Created by Vijendra.Yadav on 01/04/26.
//

import Foundation
import UIKit

enum PriceDirection: Codable {
	case up
	case down
	case neutral
}


public struct BroadcastModel: Codable {
	var tokenId: String = ""
	var name: String = ""
	var fullName: String = ""
	var country: String = ""
	var openPrice: Double = 0.0
	var latestPrice: Double = 0.0
	var priceChange: Double = 0.0
	var percentChange: Double = 0.0
	var description: String = ""
	var priceDirection: PriceDirection = .neutral
}

extension BroadcastModel: Equatable {
	
	public static func == (lhs: BroadcastModel, rhs: BroadcastModel) -> Bool {
		return lhs.tokenId == rhs.tokenId
	}
	
}
