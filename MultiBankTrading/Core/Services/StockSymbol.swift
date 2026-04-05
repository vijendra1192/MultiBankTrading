//
//  StockSymbol.swift
//  MultiBankStockPrice
//
//  Created by Vijendra.Yadav on 01/04/26.
//

import Foundation

// MARK: script cases
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

// MARK: script price range & open price
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

// MARK: script description
extension StockSymbol {
	
	var description: String {
		switch self {
				
			case .AAPL_OQ:
				return "Apple Inc. designs and manufactures consumer electronics like iPhone, Mac, and iPad.\nIt also provides services including App Store, iCloud, and Apple Music."
				
			case .CA_PA:
				return "Carrefour is a leading French multinational retail corporation.\nIt operates hypermarkets, supermarkets, and convenience stores globally."
				
			case .CDI_PA:
				return "Christian Dior is a globally recognized luxury fashion house.\nIt specializes in haute couture, ready-to-wear, and premium accessories."
				
			case .CPRI_N:
				return "Capri Holdings is a global fashion luxury group.\nIt owns brands like Michael Kors, Versace, and Jimmy Choo."
				
			case .DIS_N:
				return "Disney is a global leader in entertainment and media.\nIts businesses include movies, streaming, and theme parks."
				
			case .EL_N:
				return "Estée Lauder is a premium cosmetics and skincare company.\nIt owns multiple luxury beauty brands worldwide."
				
			case .F_N:
				return "Ford is a major American automobile manufacturer.\nIt focuses on trucks, SUVs, and electric vehicle innovation."
				
			case .GM_N:
				return "General Motors is a global automotive company.\nIt produces vehicles under brands like Chevrolet, GMC, and Cadillac."
				
			case .GOOGL_OQ:
				return "Alphabet is the parent company of Google.\nIt leads in search, advertising, cloud computing, and AI technologies."
				
			case .MCD_N:
				return "McDonald's is the world’s largest fast-food chain.\nIt operates restaurants across more than 100 countries."
				
			case .MSFT_OQ:
				return "Microsoft develops software, cloud, and enterprise solutions.\nKey products include Windows, Azure, and Office."
				
			case .MSGS_N:
				return "MSG Sports owns professional sports teams.\nIt includes the New York Knicks and New York Rangers."
				
			case .NKE_N:
				return "Nike is a global leader in sportswear and footwear.\nIt designs athletic apparel and performance gear."
				
			case .PEP_N:
				return "PepsiCo produces food and beverage products.\nIts portfolio includes Pepsi, Lay’s, and Gatorade."
				
			case .PG_N:
				return "Procter & Gamble manufactures consumer goods.\nBrands include Tide, Pampers, and Gillette."
				
			case .RACE_N:
				return "Ferrari designs luxury sports cars.\nIt is known for performance vehicles and racing heritage."
				
			case .RMS_PA:
				return "Hermès is a luxury fashion and lifestyle brand.\nIt is famous for high-end leather goods and accessories."
				
			case .TM_N:
				return "Toyota is one of the largest automobile manufacturers.\nIt is known for reliability and hybrid technology."
				
			case .TSLA_OQ:
				return "Tesla focuses on electric vehicles and clean energy.\nIt also develops batteries and solar products."
				
			case .VOW:
				return "Volkswagen is a major global automotive group.\nIt owns brands like Audi, Porsche, and Skoda."
				
			case .WMT:
				return "Walmart is the world’s largest retailer.\nIt operates stores and e-commerce platforms globally."
				
			case .AMZN:
				return "Amazon is a leading e-commerce and cloud company.\nIts services include AWS, Prime, and logistics."
				
			case .AVGO:
				return "Broadcom develops semiconductor and infrastructure software.\nIt serves data centers, networking, and wireless markets."
				
			case .META:
				return "Meta operates social media platforms like Facebook and Instagram.\nIt is investing heavily in virtual reality and the metaverse."
				
			case .CSCO:
				return "Cisco provides networking and IT infrastructure solutions.\nIt supports enterprise connectivity and security."
				
			case .LLY:
				return "Eli Lilly is a pharmaceutical company.\nIt develops medicines for diabetes, cancer, and other diseases."
				
			case .JPM:
				return "JPMorgan Chase is a global financial services firm.\nIt offers banking, investment, and asset management services."
				
			case .XOM:
				return "ExxonMobil is a major oil and gas company.\nIt explores, produces, and refines energy resources."
				
			case .JNJ:
				return "Johnson & Johnson is a healthcare company.\nIt produces pharmaceuticals, medical devices, and consumer health products."
				
			case .MA:
				return "Mastercard operates a global payment network.\nIt enables secure digital transactions worldwide."
				
			case .KO:
				return "Coca-Cola produces beverages sold globally.\nIts portfolio includes soft drinks, juices, and water."
				
			case .ORCL:
				return "Oracle provides database and cloud solutions.\nIt supports enterprise software and infrastructure services."
		}
	}
}

// MARK: script full name
extension StockSymbol {
	
	var fullName: String {
		switch self {
			case .AAPL_OQ: return "Apple Inc."
			case .CA_PA: return "Carrefour S.A."
			case .CDI_PA: return "Christian Dior SE"
			case .CPRI_N: return "Capri Holdings Limited"
			case .DIS_N: return "The Walt Disney Company"
			case .EL_N: return "The Estée Lauder Companies Inc."
			case .F_N: return "Ford Motor Company"
			case .GM_N: return "General Motors Company"
			case .GOOGL_OQ: return "Alphabet Inc."
			case .MCD_N: return "McDonald's Corporation"
			case .MSFT_OQ: return "Microsoft Corporation"
			case .MSGS_N: return "Madison Square Garden Sports Corp."
			case .NKE_N: return "NIKE, Inc."
			case .PEP_N: return "PepsiCo, Inc."
			case .PG_N: return "Procter & Gamble Company"
			case .RACE_N: return "Ferrari N.V."
			case .RMS_PA: return "Hermès International"
			case .TM_N: return "Toyota Motor Corporation"
			case .TSLA_OQ: return "Tesla, Inc."
			case .VOW: return "Volkswagen AG"
			case .WMT: return "Walmart Inc."
			case .AMZN: return "Amazon.com, Inc."
			case .AVGO: return "Broadcom Inc."
			case .META: return "Meta Platforms, Inc."
			case .CSCO: return "Cisco Systems, Inc."
			case .LLY: return "Eli Lilly and Company"
			case .JPM: return "JPMorgan Chase & Co."
			case .XOM: return "Exxon Mobil Corporation"
			case .JNJ: return "Johnson & Johnson"
			case .MA: return "Mastercard Incorporated"
			case .KO: return "The Coca-Cola Company"
			case .ORCL: return "Oracle Corporation"
		}
	}
}
