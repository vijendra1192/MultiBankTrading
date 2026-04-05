//
//  StockSymbol.swift
//  MultiBankStockPrice
//
//  Created by Vijendra.Yadav on 01/04/26.
//

import Foundation

enum StockSymbol: String, CaseIterable {
	
	case AAPL_OQ = "AAPL.OQ"
	case CA_PA = "CA.PA"
	case CDI_PA = "CDI.PA"
	case CPRI_N = "CPRI.N"
	case DIS_N = "DIS.N"
	case EL_N = "EL.N"
	case F_N = "F.N"
	case GM_N = "GM.N"
	case GOOGL_OQ = "GOOGL.OQ"
	case MCD_N = "MCD.N"
	case MSFT_OQ = "MSFT.OQ"
	case MSGS_N = "MSGS.N"
	case NKE_N = "NKE.N"
	case PEP_N = "PEP.N"
	case PG_N = "PG.N"
	case RACE_N = "RACE.N"
	case RMS_PA = "RMS.PA"
	case TM_N = "TM.N"
	case TSLA_OQ = "TSLA.OQ"
	case VOW = "VOW"
	case WMT = "WMT"
	case AMZN = "AMZN"
	case AVGO = "AVGO"
	case META = "META"
	case CSCO = "CSCO"
	case LLY = "LLY"
	case JPM = "JPM"
	case XOM = "XOM"
	case JNJ = "JNJ"
	case MA = "MA"
	case KO = "KO"
	case ORCL = "ORCL"
	
	static func getType(symbol: String) -> StockSymbol {
		StockSymbol(rawValue: symbol) ?? .AAPL_OQ
	}
}

extension StockSymbol {
	
	var range: ClosedRange<Double> {
		switch self {
			case .AAPL_OQ: return 200...260
			case .CA_PA: return 10...20
			case .CDI_PA: return 420...480
			case .CPRI_N: return 35...70
			case .DIS_N: return 80...120
			case .EL_N: return 120...180
			case .F_N: return 10...20
			case .GM_N: return 30...50
			case .GOOGL_OQ: return 120...180
			case .MCD_N: return 250...320
			case .MSFT_OQ: return 280...360
			case .MSGS_N: return 150...220
			case .NKE_N: return 90...140
			case .PEP_N: return 150...200
			case .PG_N: return 140...180
			case .RACE_N: return 280...360
			case .RMS_PA: return 1200...1800
			case .TM_N: return 150...220
			case .TSLA_OQ: return 180...300
			case .VOW: return 90...140
			case .WMT: return 140...180
			case .AMZN: return 100...160
			case .AVGO: return 900...1300
			case .META: return 250...350
			case .CSCO: return 40...70
			case .LLY: return 600...900
			case .JPM: return 130...190
			case .XOM: return 90...140
			case .JNJ: return 140...180
			case .MA: return 300...420
			case .KO: return 50...75
			case .ORCL: return 90...140
		}
	}
	
	var openPrice: Double {
		switch self {
			case .AAPL_OQ: return 220
			case .CA_PA: return 14
			case .CDI_PA: return 450
			case .CPRI_N: return 50
			case .DIS_N: return 95
			case .EL_N: return 140
			case .F_N: return 13
			case .GM_N: return 38
			case .GOOGL_OQ: return 140
			case .MCD_N: return 280
			case .MSFT_OQ: return 310
			case .MSGS_N: return 180
			case .NKE_N: return 110
			case .PEP_N: return 170
			case .PG_N: return 155
			case .RACE_N: return 310
			case .RMS_PA: return 1500
			case .TM_N: return 180
			case .TSLA_OQ: return 220
			case .VOW: return 110
			case .WMT: return 160
			case .AMZN: return 130
			case .AVGO: return 1100
			case .META: return 300
			case .CSCO: return 55
			case .LLY: return 750
			case .JPM: return 160
			case .XOM: return 110
			case .JNJ: return 160
			case .MA: return 350
			case .KO: return 60
			case .ORCL: return 110
		}
	}
}

extension StockSymbol {
	
	var description: String {
		switch self {
			case .AAPL_OQ: return "Apple Inc. - Consumer electronics and iPhones"
			case .CA_PA: return "Carrefour - French multinational retail corporation"
			case .CDI_PA: return "Christian Dior - Luxury fashion brand"
			case .CPRI_N: return "Capri Holdings - Luxury fashion group (Michael Kors, Versace)"
			case .DIS_N: return "Disney - Media, entertainment, and theme parks"
			case .EL_N: return "Estee Lauder - Cosmetics and skincare"
			case .F_N: return "Ford - Automobile manufacturer"
			case .GM_N: return "General Motors - Automobile manufacturer"
			case .GOOGL_OQ: return "Alphabet (Google) - Search, ads, and cloud"
			case .MCD_N: return "McDonald's - Fast food chain"
			case .MSFT_OQ: return "Microsoft - Software, cloud, and AI"
			case .MSGS_N: return "Madison Square Garden Sports - Sports teams business"
			case .NKE_N: return "Nike - Sportswear and footwear"
			case .PEP_N: return "PepsiCo - Food and beverages"
			case .PG_N: return "Procter & Gamble - Consumer goods"
			case .RACE_N: return "Ferrari - Luxury sports cars"
			case .RMS_PA: return "Hermes - Luxury fashion brand"
			case .TM_N: return "Toyota - Automobile manufacturer"
			case .TSLA_OQ: return "Tesla - Electric vehicles and energy"
			case .VOW: return "Volkswagen - Automobile manufacturer"
			case .WMT: return "Walmart - Retail corporation"
			case .AMZN: return "Amazon - E-commerce and cloud"
			case .AVGO: return "Broadcom - Semiconductor company"
			case .META: return "Meta - Social media and VR"
			case .CSCO: return "Cisco - Networking and IT infrastructure"
			case .LLY: return "Eli Lilly - Pharmaceutical company"
			case .JPM: return "JPMorgan Chase - Banking and financial services"
			case .XOM: return "ExxonMobil - Oil and gas"
			case .JNJ: return "Johnson & Johnson - Healthcare products"
			case .MA: return "Mastercard - Payment network"
			case .KO: return "Coca-Cola - Beverages"
			case .ORCL: return "Oracle - Database and cloud services"
		}
	}
}
