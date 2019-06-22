/*
 *	StubServerTests.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/2/19.
 *	Copyright 2019. All rights reserved.
 */

import XCTest
@testable import LocalServer

// MARK: - Definitions -

enum CustomError : Error {
	case generic
}

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
			let httpResponse = response as! HTTPURLResponse
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
			let httpResponse = response as! HTTPURLResponse
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
			let httpResponse = response as! HTTPURLResponse
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
			let httpResponse = response as! HTTPURLResponse
			XCTAssertEqual(httpResponse.statusCode, 999)
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testStubServer_WithErrorResponse_ShouldReturnTheDefinedError() {
		
		let server = StubServer()
		
		server.route(HTTPMethod.allCases, url: ".*") { (request, parameters) -> StubResponse in
			return StubResponse().withError(CustomError.generic)
		}
		
		StubServer.instance = server
		
		let expect = expectation(description: "\(#function)")
		var request = URLRequest(url: .httpbinPOST)
		request.httpMethod = HTTPMethod.PUT.rawValue
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			XCTAssertNotNil(error)
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testStubServer_WithStubResponseShortcut_ShouldReturn900ToGoogleAndAnythingBut900ToOthers() {
		
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
		StubServer.instance = nil
	}
}
