//
//  StockDetailsViewController.swift
//  MultiBankTrading
//
//  Created by Vijendra.Yadav on 05/04/26.
//

import UIKit

final class StockDetailsViewController: UIViewController {
	
	var tokenId: String = ""
	weak var watchlistViewModel: WatchlistViewModel?
	
	@IBOutlet private var scriptNameLabel: UILabel!
	@IBOutlet private var countryLabel: UILabel!
	@IBOutlet private var priceLabel: UILabel!
	@IBOutlet private var changeLabel: UILabel!
	@IBOutlet private var descriptionLabel: UILabel!
	@IBOutlet private var buyButton: UIButton!
	@IBOutlet private var sellButton: UIButton!
	
	init() {
        super.init(nibName: AppConstants.NibFileNames.stockDetailsController, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = AppColors.sheetBackground
		configureChrome()
		refreshFromWatchlist()
	}
	
	private func configureChrome() {
		scriptNameLabel.textColor = AppColors.primaryText
		scriptNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
		
		countryLabel.textColor = AppColors.secondaryText
		countryLabel.font = .systemFont(ofSize: 14, weight: .regular)
		
		priceLabel.textColor = AppColors.primaryText
		priceLabel.font = .systemFont(ofSize: 17, weight: .semibold)
		priceLabel.textAlignment = .right
		
		changeLabel.font = .systemFont(ofSize: 13, weight: .medium)
		changeLabel.textAlignment = .right
		changeLabel.layer.cornerRadius = 4
		changeLabel.layer.masksToBounds = true
		
		descriptionLabel.textColor = AppColors.secondaryText
		descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
		descriptionLabel.numberOfLines = 0
		
        styleActionButton(buyButton, title: AppConstants.ButtonTitle.buy, background: AppColors.gainBadgeBg, titleColor: AppColors.gainBadgeText)
		styleActionButton(sellButton, title: AppConstants.ButtonTitle.sell, background: AppColors.lossBadgeBg, titleColor: AppColors.lossBadgeText)
	}
	
	private func styleActionButton(_ button: UIButton, title: String, background: UIColor, titleColor: UIColor) {
		button.setTitle(title, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
		button.backgroundColor = background
		button.setTitleColor(titleColor, for: .normal)
		button.layer.cornerRadius = 10
		button.layer.masksToBounds = true
	}
	
	func refreshFromWatchlist() {
		guard let model = watchlistViewModel?.broadcastModel(forTokenId: tokenId) else { return }
		configure(with: model)
	}
	
	func configure(with model: BroadcastModel) {
		loadViewIfNeeded()
		scriptNameLabel.text = model.tokenId
		countryLabel.text = model.fullName
		priceLabel.text = String(format: "$%.2f", model.latestPrice)
		
		let sign: String = model.priceUIConfig.sign
		let arrow: String = model.priceUIConfig.arrow
		let bgColor: UIColor = model.priceUIConfig.bgColor
		let textColor: UIColor = model.priceUIConfig.textColor
		
		changeLabel.text = "  \(arrow)\(sign)\(String(format: "%.2f", model.percentChange))%  "
		changeLabel.backgroundColor = bgColor
		changeLabel.textColor = textColor
		
		let desc = model.description.trimmingCharacters(in: .whitespacesAndNewlines)
		descriptionLabel.text = desc.isEmpty ? "—" : desc
	}
	
	@IBAction private func buyTapped(_ sender: UIButton) {
        view.showToast(message: AppConstants.MessageShow.featureComing)
	}
	
	@IBAction private func sellTapped(_ sender: UIButton) {
		view.showToast(message: AppConstants.MessageShow.featureComing)
	}
	
}
