//
//  AppColors.swift
//  MultiBankStockPrice
//
//  Created by Vijendra.Yadav on 01/04/26.
//

import UIKit

enum AppColors {
	
	// MARK: - Background
	
	static let background		= UIColor.black
	static let cardBackground	= UIColor(white: 0.10, alpha: 1)
	static let footerBackground = UIColor(white: 1, alpha: 0.05)
	static let separator		= UIColor(white: 1, alpha: 0.08)
	static let searchField		= UIColor(white: 1, alpha: 0.08)
	static let buttonBackground = UIColor(white: 1, alpha: 0.12)
	
	// MARK: - Text
	
	static let primaryText		= UIColor.white
	static let secondaryText	= UIColor.lightGray
	static let placeholderText	= UIColor.gray
	
	// MARK: - Live Indicator
	
	static let liveGreen		= UIColor(red: 0.30, green: 0.85, blue: 0.40, alpha: 1)
	
	// MARK: - Price Change - Up
	
	static let gainBadgeBg		= UIColor(red: 0.15, green: 0.35, blue: 0.18, alpha: 1)
	static let gainBadgeText	= UIColor(red: 0.40, green: 0.90, blue: 0.45, alpha: 1)
	
	// MARK: - Price Change - Down
	
	static let lossBadgeBg		= UIColor(red: 0.38, green: 0.14, blue: 0.16, alpha: 1)
	static let lossBadgeText	= UIColor(red: 0.95, green: 0.40, blue: 0.42, alpha: 1)
	
	// MARK: - Price Change - Neutral
	
	static let neutralBadgeBg	= UIColor(white: 1, alpha: 0.08)
	static let neutralBadgeText = UIColor.gray
	
	// MARK: - Sort/Filter Sheet
	
	static let sheetBackground	= UIColor(white: 0.12, alpha: 1)
	static let chipDefault		= UIColor(white: 1, alpha: 0.10)
	static let chipSelected		= UIColor.white
	static let chipTextDefault	= UIColor.white
	static let chipTextSelected = UIColor.black
	static let sectionHeader	= UIColor(white: 1, alpha: 0.50)
	static let handleBar		= UIColor(white: 1, alpha: 0.30)
}
