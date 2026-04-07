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

struct PriceUIConfig {
	let sign: String
	let arrow: String
	let bgColor: UIColor
	let textColor: UIColor
}

// MARK: PriceUIConfig
extension BroadcastModel {
	
	var priceUIConfig: PriceUIConfig {
		switch priceDirection {
			case .up:
				return PriceUIConfig(
					sign: "+",
					arrow: "\u{25B2} ",
					bgColor: AppColors.gainBadgeBg,
					textColor: AppColors.gainBadgeText
				)
			case .down:
				return PriceUIConfig(
					sign: "",
					arrow: "\u{25BC} ",
					bgColor: AppColors.lossBadgeBg,
					textColor: AppColors.lossBadgeText
				)
			case .neutral:
				return PriceUIConfig(
					sign: "",
					arrow: "",
					bgColor: AppColors.neutralBadgeBg,
					textColor: AppColors.neutralBadgeText
				)
		}
	}
}
