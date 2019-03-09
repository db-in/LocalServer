/*
 *	TestBuilder.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/9/19.
 *	Copyright 2019 Emirates Group. All rights reserved.
 */

import XCTest
import LocalServer

// MARK: - Definitions -

fileprivate var appKey: String = "appKey"

// MARK: - Type -

extension XCTestCase {
	
	var main: Screen {
		return objc_getAssociatedObject(self, &appKey) as! Screen
	}
	
	func resetAndlaunch() {
		let app = XCUIApplication()
		app.launchArguments = ["-UITests"]
		app.launchEnvironment = [UITestServer.environmentKey : UITestServer.environmentInfo]
		app.launch()
		UITestServer.resetAll()
		objc_setAssociatedObject(self, &appKey, Screen(app), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
}
