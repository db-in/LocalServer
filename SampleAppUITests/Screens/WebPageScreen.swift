/*
 *	WebPageScreen.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/9/19.
 *	Copyright 2019 Emirates Group. All rights reserved.
 */

import XCTest

// MARK: - Definitions -

// MARK: - Type -

class WebPageScreen : Screen {
	
// MARK: - Properties
	
	private lazy var webView = app.otherElements["webview.page"].webViews.firstMatch
	private lazy var greetingsText = app.webViews.staticTexts["Hi, My name is"]
	
	
// MARK: - Constructors
	
	required init(_ app: XCUIApplication) {
		super.init(app)
	}
	
// MARK: - Exposed Methods
	
	@discardableResult
	func waitForWebView() -> Bool {
		return exists(webView)
	}
	
	func isGreetingsShown() -> Bool {
		return exists(greetingsText)
	}
	
	func isTextShown(_ text: String) -> Bool {
		return exists(webView.staticTexts[text])
	}
}
