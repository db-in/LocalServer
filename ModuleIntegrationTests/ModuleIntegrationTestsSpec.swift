/*
 *  ModuleIntegrationTestsSpec.swift
 *  LocalServer
 *
 *  Created by DINEY B ALVES on 11/27/18.
 *  Copyright 2018. All rights reserved.
 */

import XCTest
import LocalServer

// MARK: - Definitions -

extension URL {
	static let httpbin200 = URL(string: "https://httpbin.org/status/200")!
}

// MARK: - Type -

class ModuleIntegrationTestsSpec : XCTestCase {

// MARK: - Properties
	
// MARK: - Protected Methods

// MARK: - Exposed Methods

	func testLocalServer_WithStubServerToAnyEndpoint_ShouldReturn999() {
		
		TestLocalServer.startLocalServer()
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: .httpbin200)) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else { return }
			XCTAssertEqual(httpResponse.statusCode, 999)
			expect.fulfill()
		}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testLocalServer_WithNormalInternetConnection_ShouldReturnAnythingBut999() {
		
		TestLocalServer.stopLocalServer()
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: .httpbin200)) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else { return }
			XCTAssertNotEqual(httpResponse.statusCode, 999)
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 15.0)
	}

// MARK: - Overridden Methods

}
