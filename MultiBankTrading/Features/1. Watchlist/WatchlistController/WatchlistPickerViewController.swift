//
//  WatchlistPickerViewController.swift
//  MultiBankTrading
//

import UIKit

enum WatchlistPickerOption: CaseIterable {
	case myWatchlist
	case tech
	case automotive
	
	var title: String {
		switch self {
		case .myWatchlist: return "My watchlist"
		case .tech: return "Tech"
		case .automotive: return "Automotive"
		}
	}
    
    var getSymbols: [String] {
        switch self {
        case .myWatchlist: return StockSymbol.allCases.map(\.rawValue)
        case .tech: return StockSymbol.techSymbols
        case .automotive: return StockSymbol.automotiveSymbols
        }
    }
}

/// Compact watchlist list for popover presentation; solid `AppColors` (no system blur).
final class WatchlistPickerViewController: UIViewController {
	
	var selectedOption: WatchlistPickerOption = .myWatchlist
	var onSelect: ((WatchlistPickerOption) -> Void)?
	
	private let rowHeight: CGFloat = 48
	private lazy var tableView: UITableView = {
		let tv = UITableView(frame: .zero, style: .plain)
		tv.translatesAutoresizingMaskIntoConstraints = false
		tv.dataSource = self
		tv.delegate = self
		tv.backgroundColor = AppColors.sheetBackground
		tv.separatorColor = AppColors.separator
		tv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		tv.rowHeight = rowHeight
		tv.estimatedRowHeight = rowHeight
		tv.isScrollEnabled = false
		tv.bounces = false
		tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		return tv
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = AppColors.sheetBackground
		view.addSubview(tableView)
		let pad: CGFloat = 6
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: pad),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -pad),
		])
		updatePreferredSize()
	}
	
	private func updatePreferredSize() {
		let count = CGFloat(WatchlistPickerOption.allCases.count)
		let verticalPad: CGFloat = 12
		preferredContentSize = CGSize(width: 252, height: verticalPad + count * rowHeight)
	}
}

extension WatchlistPickerViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		WatchlistPickerOption.allCases.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let option = WatchlistPickerOption.allCases[indexPath.row]
		var config = cell.defaultContentConfiguration()
		config.text = option.title
		config.textProperties.color = AppColors.primaryText
		config.textProperties.font = .systemFont(ofSize: 17, weight: option == selectedOption ? .semibold : .regular)
		cell.contentConfiguration = config
		cell.backgroundColor = .clear
		cell.selectionStyle = .default
		let highlight = UIView()
		highlight.backgroundColor = UIColor(white: 1, alpha: 0.08)
		cell.selectedBackgroundView = highlight
		cell.accessoryType = option == selectedOption ? .checkmark : .none
		cell.tintColor = AppColors.primaryText
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		let option = WatchlistPickerOption.allCases[indexPath.row]
		onSelect?(option)
	}
}
