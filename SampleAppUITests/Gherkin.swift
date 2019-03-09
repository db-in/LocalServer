/*
 *	Gherkin.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/9/19.
 *	Copyright 2019 Emirates Group. All rights reserved.
 */

import XCTest

// MARK: - Definitions -

typealias VoidClosure = () -> Void

// MARK: - Type -

extension XCTestCase {

// MARK: - Exposed Methods
	
	func given(_ text: String, step: VoidClosure) {
		step()
		resetAndlaunch()
		continueAfterFailure = false
		XCTContext.runActivity(named: "Given " + text) { _ in }
	}
	
	func when(_ text: String, step: VoidClosure) {
		XCTContext.runActivity(named: "When " + text) { _ in
			step()
		}
	}
	
	func then(_ text: String, step: VoidClosure) {
		XCTContext.runActivity(named: "Then " + text) { _ in
			step()
		}
	}
	
	func and(_ text: String, step: VoidClosure) {
		XCTContext.runActivity(named: "And " + text) { _ in
			step()
		}
	}
}
