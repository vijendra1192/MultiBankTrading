//
//  WatchlistViewController.swift
//  MultiBankTrading
//
//  Created by Vijendra.Yadav on 05/04/26.
//

import UIKit

class WatchlistViewController: UIViewController {
	
	// MARK: - IBOutlets
	@IBOutlet private weak var watchlistMenuButton: UIButton!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var liveDot: UIView!
	@IBOutlet private weak var liveLabel: UILabel!
	@IBOutlet private weak var feedButton: UIButton!
	@IBOutlet private weak var searchBar: UISearchBar!
	@IBOutlet private weak var filterButton: UIButton!
	@IBOutlet private weak var stockTableView: UITableView!
	
	// MARK: - ViewModel
	private let viewModel = WatchlistViewModel()
	private lazy var coordinator: WatchlistCoordinating = WatchlistCoordinator(presenter: self)
	private weak var presentedStockDetails: StockDetailsViewController?
	private var selectedWatchlist: WatchlistPickerOption = .myWatchlist
	
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
		titleLabel.text = selectedWatchlist.title
		
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
		stockTableView.allowsSelection = true
		stockTableView.dataSource = self
		stockTableView.delegate = self
		stockTableView.register(StockCell.self, forCellReuseIdentifier: StockCell.reuseID)
		
		watchlistMenuButton.setTitle(nil, for: .normal)
	}
	
	// MARK: - IBActions
	@IBAction func feedButtonTapped() {
		viewModel.toggleFeed()
	}
	
	@IBAction func watchlistSelectionTapped(_ sender: Any) {
		coordinator.showWatchlistPicker(
			from: sender,
			fallbackAnchorView: titleLabel,
			selectedOption: selectedWatchlist,
			popoverDelegate: self
		) { [weak self] option in
			self?.applyWatchlistSelection(option)
		}
	}
	
	private func applyWatchlistSelection(_ option: WatchlistPickerOption) {
		selectedWatchlist = option
		titleLabel.text = option.title
        viewModel.setRandomPriceForWatchlistSelection(option: option)
        
	}
    
    private func refreshPresentedStockDetailsIfNeeded(updatedIndices: [Int]) {
		guard let details = presentedStockDetails else { return }
		for index in updatedIndices where index < viewModel.filteredStocks.count {
			if viewModel.filteredStocks[index].tokenId == details.tokenId {
				details.refreshFromWatchlist()
				return
			}
		}
	}
	
	@objc private func filterButtonTapped() {
		coordinator.showSortFilter(currentSort: viewModel.currentSort, delegate: self)
	}
	
}

// MARK: - WatchlistViewModelDelegate
extension WatchlistViewController: WatchlistViewModelDelegate {
	
	func didInsertStocks(at indices: [Int]) {
		let indexPaths = indices.map { IndexPath(row: $0, section: 0) }
		stockTableView.insertRows(at: indexPaths, with: .none)
	}
	
	func didUpdateStocks(at indices: [Int]) {
		for index in indices {
			let indexPath = IndexPath(row: index, section: 0)
			if let cell = stockTableView.cellForRow(at: indexPath) as? StockCell {
				cell.configure(with: viewModel.filteredStocks[index])
			}
		}
		refreshPresentedStockDetailsIfNeeded(updatedIndices: indices)
	}
	
	func didReloadAllStocks() {
		stockTableView.reloadData()
		presentedStockDetails?.refreshFromWatchlist()
	}
	
	func didChangeLiveState(isLive: Bool) {
		liveDot.isHidden = !isLive
		liveLabel.isHidden = !isLive
        feedButton.setTitle(isLive ? AppConstants.ButtonTitle.stopFeed : AppConstants.ButtonTitle.startFeed, for: .normal)
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		let model = viewModel.filteredStocks[indexPath.row]
		presentedStockDetails = coordinator.showStockDetails(for: model, viewModel: viewModel)
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

// MARK: - UIPopoverPresentationControllerDelegate

extension WatchlistViewController: UIPopoverPresentationControllerDelegate {
	
	func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		.none
	}
}
