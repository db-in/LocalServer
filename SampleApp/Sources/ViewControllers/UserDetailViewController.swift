//
//  UserDetailViewController.swift
//  SampleApp
//
//  Created by DINEY B ALVES on 3/9/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

extension UIImageView {
	
	private func updateImage(_ image: UIImage?) {
		
		DispatchQueue.main.async { [weak self] in
			self?.image = image
		}
	}
	
	func loadImage(from url: URL?) {
		
		guard let validURL = url else { return }
		
		let task = URLSession.shared.dataTask(with: validURL) { [weak self] (data, _, _) in
			guard let validData = data else { return }
			self?.updateImage(UIImage(data: validData))
		}
		
		task.resume()
	}
}

class UserDetailViewController: UIViewController {

	@IBOutlet weak var pictureImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var moreButton: UIButton!
	
	var detailItem: User?

	func configureView() {
		pictureImageView.loadImage(from: detailItem?.picture?.url)
		pictureImageView.layer.cornerRadius = pictureImageView.bounds.size.width * 0.5
		pictureImageView.layer.masksToBounds = true
		titleLabel.text = detailItem?.fullName
		subtitleLabel.text = detailItem?.email
		
		pictureImageView.accessibilityIdentifier = "imageView.user.profile"
		titleLabel.accessibilityIdentifier = "label.user.name"
		subtitleLabel.accessibilityIdentifier = "label.user.email"
		moreButton.accessibilityIdentifier = "button.more"
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureView()
	}
}
