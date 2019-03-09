/*
 *	Screen.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/9/19.
 *	Copyright 2019 Emirates Group. All rights reserved.
 */

import XCTest

// MARK: - Definitions -

enum UIState: String {
	case exist = "exists == true"
	case notExist = "exists == false"
	case hittable = "isHittable == true"
	
	var predicate: NSPredicate {
		return NSPredicate(format: rawValue)
	}
}

// MARK: - Type -

class Screen {
	
	var app: XCUIApplication
	
	required init(_ app: XCUIApplication) {
		self.app = app
	}
	
	func on<T: Screen>(screen: T.Type) -> T {
		let nextScreen: T
		
		if self is T {
			nextScreen = self as! T
		} else {
			nextScreen = screen.init(app)
		}
		
		return nextScreen
	}
}

extension Screen {
	
	@discardableResult
	func wait(for element: XCUIElement, state: UIState, timeout: Int = 10) -> XCTWaiter.Result {
		let expectation = XCTNSPredicateExpectation(predicate: state.predicate, object: element)
		let result = XCTWaiter.wait(for: [expectation], timeout: TimeInterval(timeout))
		
		if (result == .timedOut) {
			XCTFail(expectation.description)
		}
		
		return result
	}
	
	func tap(_ element: XCUIElement, timeout: Int = 10) {
		wait(for: element, state: .hittable, timeout: timeout)
		element.tap()
	}
	
	func exists(_ element: XCUIElement, timeout: Int = 10) -> Bool {
		return wait(for: element, state: .exist, timeout: timeout) != .timedOut
	}
	
	internal func label(of element: XCUIElement, timeout: Int = 10) -> String {
		wait(for: element, state: .exist, timeout: timeout)
		return element.label
	}
	
	func enabled(_ element: XCUIElement) -> Bool {
		return element.isEnabled
	}
}

// MARK: - Extension - Bundle

extension Bundle {
	
	static var uiTest: Bundle {
		return Bundle(for: Screen.self)
	}
}
