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
			let httpResponse = response as! HTTPURLResponse
			XCTAssertEqual(httpResponse.statusCode, 999)
			expect.fulfill()
		}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testLocalServer_WithNormalInternetConnection_ShouldReturnAnythingBut999() {
		
		TestLocalServer.stopLocalServer()
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: .httpbin200)) { data, response, error in
			let httpResponse = response as! HTTPURLResponse
			XCTAssertNotEqual(httpResponse.statusCode, 999)
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 15.0)
	}
	
	func test_LocalServer_WithStubResponseShortcut_ShouldReturn900ToGoogleAndAnythingBut900ToOthers() {
		
		let statusCode = 900
		let expect = expectation(description: "\(#function)")
		let group = DispatchGroup()
		
		StubResponse()
			.withStatusCode(statusCode)
			.send(to: "google")
		
		group.enter()
		URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://google.com")!)) { data, response, error in
			let httpResponse = response as! HTTPURLResponse
			XCTAssertEqual(httpResponse.statusCode, statusCode)
			group.leave()
			}.resume()
		
		group.enter()
		URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://apple.com")!)) { data, response, error in
			let httpResponse = response as! HTTPURLResponse
			XCTAssertNotEqual(httpResponse.statusCode, statusCode)
			group.leave()
			}.resume()
		
		group.notify(queue: DispatchQueue.main, execute: {
			expect.fulfill()
		})
		
		wait(for: [expect], timeout: 15.0)
	}

// MARK: - Overridden Methods
	
	override func tearDown() {
		TestLocalServer.stopLocalServer()
	}
}
