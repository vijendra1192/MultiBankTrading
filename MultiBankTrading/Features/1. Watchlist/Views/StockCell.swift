//
//  StockCell.swift
//  MultiBankStockPrice
//
//  Created by Vijendra.Yadav on 01/04/26.
//

import UIKit

final class StockCell: UITableViewCell {
	
	static let reuseID = "StockCell"
	
	private let symbolLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .bold)
		label.textColor = AppColors.primaryText
		return label
	}()
	
	private let companyLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .regular)
		label.textColor = AppColors.secondaryText
		return label
	}()
	
	private let priceLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .semibold)
		label.textColor = AppColors.primaryText
		label.textAlignment = .right
		return label
	}()
	
	private let changeBadge: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12, weight: .medium)
		label.textAlignment = .center
		label.layer.cornerRadius = 4
		label.layer.masksToBounds = true
		return label
	}()
	
	private let leftStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 2
		stack.alignment = .leading
		return stack
	}()
	
	private let rightStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 4
		stack.alignment = .trailing
		return stack
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
	
	private func setupUI() {
		backgroundColor = .clear
		contentView.backgroundColor = .clear
		selectionStyle = .none
		
		leftStack.addArrangedSubview(symbolLabel)
		leftStack.addArrangedSubview(companyLabel)
		
		rightStack.addArrangedSubview(priceLabel)
		rightStack.addArrangedSubview(changeBadge)
		
		let mainStack = UIStackView(arrangedSubviews: [leftStack, rightStack])
		mainStack.axis = .horizontal
		mainStack.spacing = 12
		mainStack.alignment = .center
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.addSubview(mainStack)
		NSLayoutConstraint.activate([
			mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
			mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
			mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			changeBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 72),
			changeBadge.heightAnchor.constraint(equalToConstant: 24),
		])
		
		let separator = UIView()
		separator.backgroundColor = .white
		separator.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(separator)
		NSLayoutConstraint.activate([
			separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			separator.heightAnchor.constraint(equalToConstant: 0.18),
		])
	}
	
	func configure(with model: BroadcastModel) {
		symbolLabel.text = model.tokenId
		companyLabel.text = "\(model.country)"
		priceLabel.text = String(format: "$%.2f", model.latestPrice)
		
		let sign: String
		let arrow: String
		let bgColor: UIColor
		let textColor: UIColor
		
		switch model.priceDirection {
		case .up:
			sign = "+"
			arrow = "\u{25B2} "
			bgColor = AppColors.gainBadgeBg
			textColor = AppColors.gainBadgeText
		case .down:
			sign = ""
			arrow = "\u{25BC} "
			bgColor = AppColors.lossBadgeBg
			textColor = AppColors.lossBadgeText
		case .neutral:
			sign = ""
			arrow = ""
			bgColor = AppColors.neutralBadgeBg
			textColor = AppColors.neutralBadgeText
		}
		
		changeBadge.text = "\(arrow)\(sign)\(String(format: "%.2f", model.percentChange))%"
		changeBadge.backgroundColor = bgColor
		changeBadge.textColor = textColor
	}
	
}
