/*
*	SampleAppUnitTests.swift
*	LocalServer
*
*	Created by Diney Bomfim on 3/1/19.
*	Copyright 2019. All rights reserved.
*/

import XCTest
import LocalServer
@testable import SampleApp

// MARK: - Definitions -

enum MockError : Error {
	case generic
}

// MARK: - Type -

class SampleAppUnitTests : XCTestCase {

// MARK: - Properties

// MARK: - Protected Methods

// MARK: - Exposed Methods
	
	func testServiceManager_WithLoadRandomUserInSuccessfulResponse_ShouldReturnAnUser() {
		
		let expect = expectation(description: "\(#function)")
		let bundle = Bundle(for: SampleAppUnitTests.self)
		
		StubResponse(filename: "user", ofType: "json", bundle: bundle)
			.send(to: ".*")
		
		ServiceManager.shared.loadRandomUser { (user, error) in
			XCTAssertEqual(user?.fullName, "Mr Brent Robertson")
			XCTAssertEqual(user?.email, "brent.robertson36@example.com")
			XCTAssertEqual(user?.picture?.medium, "https://randomuser.me/api/portraits/med/men/14.jpg")
			expect.fulfill()
		}
		
		wait(for: [expect], timeout: 15.0)
	}
	
	func testServiceManager_WithLoadRandomUserInFailingResponse_ShouldReturnAnError() {
		
		let expect = expectation(description: "\(#function)")
		
		StubResponse()
			.withError(MockError.generic)
			.send(to: ".*")
		
		ServiceManager.shared.loadRandomUser { (user, error) in
			XCTAssertNotNil(error)
			expect.fulfill()
		}
		
		wait(for: [expect], timeout: 15.0)
	}

// MARK: - Overridden Methods

}
