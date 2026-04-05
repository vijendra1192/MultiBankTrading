//
//  UIView+Extension.swift
//  MultiBankTrading
//
//  Created by Vijendra.Yadav on 05/04/26.
//

import Foundation
import UIKit
 
extension UIView {
	
	// MARK: - Toast
	func showToast(message: String) {
		let toast = UILabel()
		toast.text = message
		toast.font = .systemFont(ofSize: 14, weight: .medium)
		toast.textColor = AppColors.primaryText
		toast.backgroundColor = AppColors.chipDefault
		toast.textAlignment = .center
		toast.layer.cornerRadius = 20
		toast.layer.masksToBounds = true
		toast.alpha = 0
		toast.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(toast)
		NSLayoutConstraint.activate([
			toast.centerXAnchor.constraint(equalTo: centerXAnchor),
			toast.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
			toast.heightAnchor.constraint(equalToConstant: 40),
			toast.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
		])
		
		UIView.animate(withDuration: 0.3, animations: { toast.alpha = 1 }) { _ in
			UIView.animate(withDuration: 0.3, delay: 1.5, options: [], animations: {
				toast.alpha = 0
			}) { _ in
				toast.removeFromSuperview()
			}
		}
	}
	
}
