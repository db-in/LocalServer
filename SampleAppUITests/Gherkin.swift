/*
 *	Gherkin.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/9/19.
 *	Copyright 2019. All rights reserved.
 */

import XCTest

// MARK: - Definitions -

typealias VoidClosure = () -> Void

// MARK: - Type -

extension XCTestCase {

// MARK: - Exposed Methods
	
	private func process(_ text: String, step: VoidClosure) {
		XCTContext.runActivity(named: text) { _ in step() }
	}
	
	func given(_ text: String, step: VoidClosure) {
		step()
		resetAndlaunch()
		continueAfterFailure = false
		process("Given " + text, step: { })
	}
	
	func when(_ text: String, step: VoidClosure) {
		process("When " + text, step: step)
	}
	
	func then(_ text: String, step: VoidClosure) {
		process("Then " + text, step: step)
	}
	
	func and(_ text: String, step: VoidClosure) {
		process("And " + text, step: step)
	}
}
