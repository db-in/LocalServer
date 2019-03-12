/*
 *	UserListScreen.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/9/19.
 *	Copyright 2019. All rights reserved.
 */

import XCTest

// MARK: - Definitions -

// MARK: - Type -

class UserListScreen : Screen {

// MARK: - Properties
	
	private lazy var addButton = app.buttons["button.add"]
	private lazy var editButton = app.buttons["button.edit"]
	private lazy var userCell = app.cells.matching(identifier: "cell.user")
	
// MARK: - Constructors
	
	required init(_ app: XCUIApplication) {
		super.init(app)
	}
	
// MARK: - Exposed Methods

	@discardableResult
	func addUser(count: Int = 1) -> Self {
		(0..<count).forEach { _ in tap(addButton) }
		return self
	}
	
	@discardableResult
	func tapUserCell(_ index: Int) -> Self {
		tap(userCell.element(boundBy: index))
		return self
	}
	
	func hasCell(at index: Int, with name: String? = nil) -> Bool {
		
		let cell = userCell.element(boundBy: index)
		
		guard let validName = name else {
			return exists(cell)
		}
		
		return exists(cell) && exists(cell.staticTexts[validName])
	}
}
