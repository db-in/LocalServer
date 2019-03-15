/*
 *	UserDetailSpec.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/9/19.
 *	Copyright 2019. All rights reserved.
 */

import XCTest

// MARK: - Definitions -

// MARK: - Type -

final class UserDetailSpec : XCTestCase {
	
	func testFemaleUserDetail() {
		given("I receive a female profile") {
			UserService.singleWithDetails(.female)
		}
		
		when("I tap the user cell") {
			main.on(screen: UserListScreen.self)
				.addUser()
				.tapUserCell(0)
		}
		
		then("I should see the user detail") {
			XCTAssert(main.on(screen: UserDetailedScreen.self).hasName(UserType.female.fullName))
		}
	}
	
	func testAddSeveralUser() {
		let count = (3...8).randomElement()!
		
		given("I receive several male profiles") {
			UserService.singleWithDetails(.female)
		}
		
		when("I tap the add button \(count) times") {
			main.on(screen: UserListScreen.self)
				.addUser(count: count)
				.tapUserCell(0)
		}
		
		then("I should see all the user cell been added to the list") {
			XCTAssert(main.on(screen: UserDetailedScreen.self).hasName(UserType.female.fullName))
		}
	}
}
