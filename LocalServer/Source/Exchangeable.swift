/*
 *	Exchangeable.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

protocol Exchangeable : AnyObject {
	
	static func exchange()
}

// MARK: - Type -

extension Exchangeable {
	
	static func exchangeInstance(_ original: Selector, _ new: Selector) {
		let originalMethod = class_getInstanceMethod(self, original)
		let newMethod = class_getInstanceMethod(self, new)
		if let originalSel = originalMethod, let newSel = newMethod {
			method_exchangeImplementations(originalSel, newSel)
		}
	}
	
	static func exchangeClass(_ original: Selector, _ new: Selector) {
		let originalMethod = class_getClassMethod(self, original)
		let newMethod = class_getClassMethod(self, new)
		if let originalSel = originalMethod, let newSel = newMethod {
			method_exchangeImplementations(originalSel, newSel)
		}
	}
}
