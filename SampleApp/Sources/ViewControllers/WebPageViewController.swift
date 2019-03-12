//
//  WebPageViewController.swift
//  SampleApp
//
//  Created by DINEY B ALVES on 3/9/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit
import WebKit

class WebPageViewController: UIViewController {

	@IBOutlet weak var webView: WKWebView!
	
	func configureView() {
		let request = URLRequest(url: URL(string: "https://randomuser.me/index")!)
		webView.load(request)
		webView.accessibilityIdentifier = "webview.page"
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureView()
	}
}
