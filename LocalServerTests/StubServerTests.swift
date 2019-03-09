/*
 *	StubServerTests.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/2/19.
 *	Copyright 2019 Emirates Group. All rights reserved.
 */

import XCTest
@testable import LocalServer

// MARK: - Definitions -

// MARK: - Type -

class StubServerTests : XCTestCase {

// MARK: - Properties

// MARK: - Constructors

// MARK: - Protected Methods

// MARK: - Exposed Methods
	
	func testStubServer_WithDefaultResponse_ShouldReturnDefaultForAnyUnmappedRoute() {
		
		let server = StubServer()
		
		StubServer.instance = server
		
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else { return }
			XCTAssertEqual(httpResponse.statusCode, server.defaultResponse.statusCode)
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}

	func testStubServer_WithARequestMadeAndAServerInterruption_ShouldResultInError() {
		
		let server = StubServer()
		
		StubServer.instance = server
		
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
			XCTAssertNotNil(error)
			expect.fulfill()
			}.resume()
		
		StubServer.instance = nil
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testStubServer_WithMethodGETAndMatchingCall_ShouldCreateStubsAccordingly() {
		
		let server = StubServer()
		
		server.route([.GET], url: "httpbin") { (request, parameters) -> StubResponse in
			return StubResponse().withStatusCode(999)
		}
		
		StubServer.instance = server
		
		let expect = expectation(description: "\(#function)")
		let getRequest = URLRequest(url: .httpbinPOST)
		
		URLSession.shared.dataTask(with: getRequest) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else { return }
			XCTAssertEqual(httpResponse.statusCode, 999)
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testStubServer_WithMethodPOSTAndNotMatchingCall_ShouldReturnDefaultResponse() {
		
		let server = StubServer()
		
		StubServer.instance = server
		
		let expect = expectation(description: "\(#function)")
		var postRequest = URLRequest(url: .httpbinPOST)
		postRequest.httpMethod = HTTPMethod.POST.rawValue
		
		URLSession.shared.dataTask(with: postRequest) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else { return }
			XCTAssertEqual(httpResponse.statusCode, server.defaultResponse.statusCode)
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testStubServer_WithAllMethodsAndMatchingCalls_ShouldStubAccordingly() {
		
		let server = StubServer()
		
		server.route(HTTPMethod.allCases, url: "httpbin") { (request, parameters) -> StubResponse in
			return StubResponse().withStatusCode(999)
		}
		
		StubServer.instance = server
		
		let expect = expectation(description: "\(#function)")
		var request = URLRequest(url: .httpbinPOST)
		request.httpMethod = HTTPMethod.PUT.rawValue
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else { return }
			XCTAssertEqual(httpResponse.statusCode, 999)
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}

// MARK: - Overridden Methods
	
}
