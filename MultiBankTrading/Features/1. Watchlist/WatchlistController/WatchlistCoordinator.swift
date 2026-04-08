//
//  WatchlistCoordinator.swift
//  MultiBankTrading
//

import UIKit

protocol WatchlistCoordinating: AnyObject {
	@discardableResult
	func showStockDetails(for model: BroadcastModel, viewModel: WatchlistViewModel) -> StockDetailsViewController?
	func showSortFilter(currentSort: SortOption, delegate: SortFilterDelegate)
	func showWatchlistPicker(
		from sender: Any,
		fallbackAnchorView: UIView,
		selectedOption: WatchlistPickerOption,
		popoverDelegate: UIPopoverPresentationControllerDelegate?,
		onSelect: @escaping (WatchlistPickerOption) -> Void
	)
}

/// Keeps Watchlist navigation in one place so the view controller stays focused on UI events.
final class WatchlistCoordinator: WatchlistCoordinating {
	private weak var presenter: UIViewController?

	init(presenter: UIViewController) {
		self.presenter = presenter
	}

	@discardableResult
	func showStockDetails(for model: BroadcastModel, viewModel: WatchlistViewModel) -> StockDetailsViewController? {
		if let existing = presenter?.presentedViewController as? StockDetailsViewController {
			existing.tokenId = model.tokenId
			existing.watchlistViewModel = viewModel
			existing.configure(with: model)
			return existing
		}

		let details = StockDetailsViewController()
		details.tokenId = model.tokenId
		details.watchlistViewModel = viewModel

		if let sheet = details.sheetPresentationController {
			sheet.detents = [.medium(), .large()]
			sheet.preferredCornerRadius = 20
			sheet.prefersGrabberVisible = true
		}

		presenter?.present(details, animated: false)
		return details
	}

	func showSortFilter(currentSort: SortOption, delegate: SortFilterDelegate) {
		let sortFilterViewController = SortFilterViewController()
		sortFilterViewController.currentSort = currentSort
		sortFilterViewController.delegate = delegate

		if let sheet = sortFilterViewController.sheetPresentationController {
			sheet.detents = [.medium()]
			sheet.preferredCornerRadius = 20
		}

		presenter?.present(sortFilterViewController, animated: false)
	}

	func showWatchlistPicker(
		from sender: Any,
		fallbackAnchorView: UIView,
		selectedOption: WatchlistPickerOption,
		popoverDelegate: UIPopoverPresentationControllerDelegate?,
		onSelect: @escaping (WatchlistPickerOption) -> Void
	) {
		let picker = WatchlistPickerViewController()
		picker.selectedOption = selectedOption
		picker.onSelect = { [weak picker] option in
			onSelect(option)
			picker?.dismiss(animated: true)
		}

		picker.modalPresentationStyle = .popover
		if let popover = picker.popoverPresentationController {
			let anchorView = (sender as? UIView) ?? fallbackAnchorView
			popover.sourceView = anchorView
			popover.sourceRect = anchorView.bounds
			popover.permittedArrowDirections = [.up, .down]
			popover.delegate = popoverDelegate
			popover.backgroundColor = AppColors.sheetBackground
		}

		presenter?.present(picker, animated: true)
	}
}
