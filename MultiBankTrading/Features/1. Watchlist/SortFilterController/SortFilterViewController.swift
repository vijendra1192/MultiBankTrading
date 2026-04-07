//
//  SortFilterViewController.swift
//  MultiBankStockPrice
//
//  Created by Vijendra.Yadav on 01/04/26.
//

import UIKit

protocol SortFilterDelegate: AnyObject {
	func didSelectSort(_ option: SortOption)
}

final class SortFilterViewController: UIViewController {
	
	weak var delegate: SortFilterDelegate?
	var currentSort: SortOption = .none
	
	// MARK: - IBOutlets
	
	@IBOutlet private var priceHighBtn: UIButton!
	@IBOutlet private var priceLowBtn: UIButton!
	@IBOutlet private var changeHighBtn: UIButton!
	@IBOutlet private var changeLowBtn: UIButton!
	@IBOutlet private var filterByButton: UIButton!
	
	// MARK: - Init
	
	init() {
        super.init(nibName: AppConstants.NibFileNames.sortAndFilterController, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateChipStates()
	}
	
	// MARK: - Chip State
	
	private func updateChipStates() {
		let allChips: [(UIButton, SortOption)] = [
			(priceHighBtn,  .priceHighToLow),
			(priceLowBtn,   .priceLowToHigh),
			(changeHighBtn, .changeHighToLow),
			(changeLowBtn,  .changeLowToHigh),
		]
		
		for (button, option) in allChips {
			let selected = currentSort == option
			button.backgroundColor = selected ? AppColors.chipSelected : AppColors.chipDefault
			button.setTitleColor(selected ? AppColors.chipTextSelected : AppColors.chipTextDefault, for: .normal)
			button.layer.borderWidth = selected ? 0 : 1
			button.layer.borderColor = selected ? UIColor.clear.cgColor : AppColors.separator.cgColor
		}
	}
	
	private func selectSort(_ option: SortOption) {
		currentSort = (currentSort == option) ? .none : option
		updateChipStates()
		delegate?.didSelectSort(currentSort)
	}
	
	// MARK: - Actions
	
	@IBAction func chipTapped(_ sender: UIButton) {
		let sortOptions: [SortOption] = [
			.priceHighToLow,
			.priceLowToHigh,
			.changeHighToLow,
			.changeLowToHigh,
		]
		guard sender.tag >= 0, sender.tag < sortOptions.count else { return }
		selectSort(sortOptions[sender.tag])
	}
	
	@IBAction func filterByTapped() {
        view.showToast(message: AppConstants.MessageShow.featureComing)
	}
	
}
