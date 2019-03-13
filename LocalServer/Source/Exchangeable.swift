/*
 *	Exchangeable.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

private typealias MethodFunction = (AnyClass?, Selector) -> Method?

protocol Exchangeable : AnyObject {
	
	static func exchange()
}

// MARK: - Type -

extension Exchangeable {
	
	static private func exchange(_ method: MethodFunction, _ original: Selector, _ new: Selector) {
		let originalMethod = method(self, original)
		let newMethod = method(self, new)
		if let originalSel = originalMethod, let newSel = newMethod {
			method_exchangeImplementations(originalSel, newSel)
		}
	}
	
	static func exchangeInstance(_ original: Selector, _ new: Selector) {
		exchange(class_getInstanceMethod, original, new)
	}
	
	static func exchangeClass(_ original: Selector, _ new: Selector) {
		exchange(class_getClassMethod, original, new)
	}
}
