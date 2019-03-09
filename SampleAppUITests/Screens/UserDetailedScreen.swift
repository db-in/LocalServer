/*
 *	UserDetailedScreen.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/9/19.
 *	Copyright 2019 Emirates Group. All rights reserved.
 */

import XCTest

// MARK: - Definitions -

// MARK: - Type -

class UserDetailedScreen : Screen {

// MARK: - Properties
	
	private lazy var profilePicture = app.images["imageView.user.profile"]
	private lazy var nameLabel = app.staticTexts["label.user.name"]
	private lazy var emailLabel = app.staticTexts["label.user.email"]
	private lazy var moreButton = app.buttons["button.more"]
	
// MARK: - Constructors
	
	required init(_ app: XCUIApplication) {
		super.init(app)
	}
	
// MARK: - Exposed Methods
	
	@discardableResult
	func tapMoreDetails() -> Self {
		tap(moreButton)
		return self
	}
	
	func hasName(_ name: String) -> Bool {
		return label(of: nameLabel).contains(name)
	}
	
	func hasEmail(_ name: String) -> Bool {
		return label(of: emailLabel).contains(name)
	}
}
