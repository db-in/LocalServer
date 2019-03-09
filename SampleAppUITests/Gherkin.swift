/*
 *	Gherkin.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/9/19.
 *	Copyright 2019 Emirates Group. All rights reserved.
 */

import XCTest

// MARK: - Definitions -

// MARK: - Type -

extension XCTestCase {

// MARK: - Exposed Methods
	
	func Given(_ text: String, step: () -> Void ) {
		step()
		resetAndlaunch()
		continueAfterFailure = false
		XCTContext.runActivity(named: "Given " + text) { _ in }
	}
	
	func When(_ text: String, step: () -> Void ) {
		XCTContext.runActivity(named: "When " + text) { _ in
			step()
		}
	}
	
	func Then(_ text: String, step: () -> Void ) {
		XCTContext.runActivity(named: "Then " + text) { _ in
			step()
		}
	}
	
	func And(_ text: String, step: () -> Void ) {
		XCTContext.runActivity(named: "And " + text) { _ in
			step()
		}
	}
}
