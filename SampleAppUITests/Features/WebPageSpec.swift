/*
 *	WebPageSpec.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/10/19.
 *	Copyright 2019. All rights reserved.
 */

import XCTest

// MARK: - Definitions -

// MARK: - Type -

final class WebPageSpec : XCTestCase {
	
	func testFemaleUserDetail() {
		given("I receive a female profile") {
			UserService.singleWithMoreInfo(.female)
		}
		
		when("I tap the user cell") {
			main.on(screen: UserListScreen.self)
				.addUser()
				.tapUserCell(0)
				.on(screen: UserDetailedScreen.self)
				.tapMoreDetails()
				.on(screen: WebPageScreen.self)
				.waitForWebView()
		}
		
		then("I should see the user detail") {
			XCTAssert(main.on(screen: WebPageScreen.self).isGreetingsShown())
			XCTAssert(main.on(screen: WebPageScreen.self).isTextShown(UserType.female.shortName))
		}
	}
}
