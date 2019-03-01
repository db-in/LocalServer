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

// MARK: - Type -

class ModuleIntegrationTestsSpec : XCTestCase {

// MARK: - Properties

// MARK: - Protected Methods

// MARK: - Exposed Methods

	func test_LocalServer_WithStubServerToAnyEndpoint_ShouldReturn999() {
		
		TestLocalServer.startLocalServer()
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://google.com")!)) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else { return }
			XCTAssertEqual(httpResponse.statusCode, 999)
			expect.fulfill()
		}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func test_LocalServer_WithNormalInternetConnection_ShouldReturnAnythingBut999() {
		
		TestLocalServer.stopLocalServer()
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://google.com")!)) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else { return }
			XCTAssertNotEqual(httpResponse.statusCode, 999)
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 15.0)
	}

// MARK: - Overridden Methods

}
