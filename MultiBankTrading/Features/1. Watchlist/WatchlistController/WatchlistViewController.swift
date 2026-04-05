//
//  WatchlistViewController.swift
//  MultiBankTrading
//
//  Created by Vijendra.Yadav on 05/04/26.
//

import UIKit

class WatchlistViewController: UIViewController {
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var liveDot: UIView!
	@IBOutlet weak var liveLabel: UILabel!
	@IBOutlet weak var feedButton: UIButton!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var filterButton: UIButton!
	@IBOutlet weak var stockTableView: UITableView!
	
	// MARK: - ViewModel
	private let viewModel = WatchlistViewModel()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.delegate = self
		configureViews()
		viewModel.startFeed()
	}
	
	deinit {
		viewModel.stopFeed()
	}
	
	// MARK: - View Configuration
	private func configureViews() {
		view.backgroundColor = AppColors.background
		
		titleLabel.textColor = AppColors.primaryText
		
		liveDot.isHidden = true
		liveDot.backgroundColor = AppColors.liveGreen
		liveLabel.isHidden = true
		liveLabel.textColor = AppColors.liveGreen
		
		feedButton.backgroundColor = AppColors.buttonBackground
		feedButton.setTitleColor(AppColors.primaryText, for: .normal)
		
		searchBar.delegate = self
		let tf = searchBar.searchTextField
		tf.textColor = AppColors.primaryText
		tf.backgroundColor = AppColors.searchField
		tf.attributedPlaceholder = NSAttributedString(
			string: "Search symbols...",
			attributes: [.foregroundColor: AppColors.placeholderText]
		)
		
		filterButton.tintColor = AppColors.primaryText
		filterButton.backgroundColor = AppColors.searchField
		let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
		filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease", withConfiguration: config), for: .normal)
		filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
		
		stockTableView.backgroundColor = .clear
		stockTableView.dataSource = self
		stockTableView.delegate = self
		stockTableView.register(StockCell.self, forCellReuseIdentifier: StockCell.reuseID)
	}
	
	// MARK: - IBActions
	@IBAction func feedButtonTapped() {
		viewModel.toggleFeed()
	}
	
	@objc private func filterButtonTapped() {
		let sortFilterVC = SortFilterViewController()
		sortFilterVC.currentSort = viewModel.currentSort
		sortFilterVC.delegate = self
		
		if let sheet = sortFilterVC.sheetPresentationController {
			sheet.detents = [.medium()]
			sheet.preferredCornerRadius = 20
		}
		present(sortFilterVC, animated: true)
	}
	
}

// MARK: - WatchlistViewModelDelegate
extension WatchlistViewController: WatchlistViewModelDelegate {
	
	func didInsertStocks(at indices: [Int]) {
		let indexPaths = indices.map { IndexPath(row: $0, section: 0) }
		stockTableView.insertRows(at: indexPaths, with: .automatic)
	}
	
	func didUpdateStocks(at indices: [Int]) {
		for index in indices {
			let indexPath = IndexPath(row: index, section: 0)
			if let cell = stockTableView.cellForRow(at: indexPath) as? StockCell {
				cell.configure(with: viewModel.filteredStocks[index])
			}
		}
	}
	
	func didReloadAllStocks() {
		stockTableView.reloadData()
	}
	
	func didChangeLiveState(isLive: Bool) {
		liveDot.isHidden = !isLive
		liveLabel.isHidden = !isLive
		feedButton.setTitle(isLive ? "Stop feed" : "Start feed", for: .normal)
	}
	
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension WatchlistViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.filteredStocks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.reuseID, for: indexPath) as? StockCell else {
			return UITableViewCell()
		}
		cell.configure(with: viewModel.filteredStocks[indexPath.row])
		return cell
	}
	
}

// MARK: - SortFilterDelegate
extension WatchlistViewController: SortFilterDelegate {
	
	func didSelectSort(_ option: SortOption) {
		viewModel.applySort(option)
	}
	
}

// MARK: - UISearchBarDelegate
extension WatchlistViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		viewModel.search(query: searchText)
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
}


