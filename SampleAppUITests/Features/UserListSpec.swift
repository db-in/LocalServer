/*
 *	UserListSpec.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/9/19.
 *	Copyright 2019 Emirates Group. All rights reserved.
 */

import XCTest

// MARK: - Definitions -

extension UserType {
	
	var fullName: String {
		switch self {
		case .male:
			return "Mr Brent Robertson"
		case .female:
			return "Miss Crystal Reed"
		}
	}
}

// MARK: - Type -

final class UserListSpec : XCTestCase {

	func testAddOneUser() {
		given("I receive a female profile") {
			UserService.single(.female)
		}
		
		when("I tap the add button") {
			main.on(screen: UserListScreen.self).addUser()
		}
		
		then("I should see a new user cell added to the list") {
			XCTAssert(main.on(screen: UserListScreen.self).hasCell(at: 0))
		}
	}
	
	func testAddDifferentUsers() {
		let userTypes: [UserType] = [.female, .male, .male]
			
		given("I receive a sequence of [female, male, male] profiles") {
			UserService.statefulSequence(userTypes)
		}
		
		when("I tap the add button") {
			main.on(screen: UserListScreen.self).addUser(count: userTypes.count)
		}
		
		then("I should see the user cell in the same order") {
			userTypes.reversed().enumerated().forEach {
				XCTAssert(main.on(screen: UserListScreen.self).hasCell(at: $0, with: $1.fullName))
			}
		}
	}
	
	func testAddSeveralUser() {
		let count = (3...8).randomElement()!
		
		given("I receive several male profiles") {
			UserService.single(.male)
		}
		
		when("I tap the add button \(count) times") {
			main.on(screen: UserListScreen.self).addUser(count: count)
		}
		
		then("I should see all the user cell been added to the list") {
			(0..<count).forEach {
				XCTAssert(main.on(screen: UserListScreen.self).hasCell(at: $0), "The cell \($0) hasn't been added")
			}
		}
	}
}
