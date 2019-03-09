/*
 *	UITestResponseTests.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import XCTest
@testable import LocalServer

// MARK: - Definitions -

// MARK: - Type -

class UITestResponseTests : XCTestCase {

// MARK: - Properties

// MARK: - Constructors

// MARK: - Protected Methods

// MARK: - Exposed Methods

	func testUITestResponse_WithGenericResponse_ShouldResultFullEnvironmentInfo() {
		UITestResponse()
			.withDelay(2)
			.withHeaders(["headerA":"valueA"])
			.withStatusCode(203)
			.withBody("{\"keyA\":\"valueA\"}".data(using: .utf8))
			.send(to: ".*")
		
		let environments = UITestServer.responses.flatMap { $0.values }
		
		XCTAssertTrue(environments.contains(where: { $0 as? Int == 203 }))
		XCTAssertTrue(environments.contains(where: { $0 as? [String : String] == ["headerA":"valueA"] }))
		XCTAssertTrue(environments.contains(where: { $0 as? String == ".*" }))
		XCTAssertTrue(environments.contains(where: { $0 as? Double == 2.0 }))
	}
	
	func testUITestResponse_WithGenericResponse_ShouldResultInitializedStubServerResponse() {
		
		UITestResponse()
			.withHeaders(["headerA":"valueA"])
			.withStatusCode(203)
			.withBody("{\"keyA\":\"valueA\"}".data(using: .utf8))
			.send(to: ".*")
		
		UITestServer.start()
		
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else { return }
			XCTAssertEqual(httpResponse.statusCode, 203)
			XCTAssertEqual(String(data: data!, encoding: .utf8), "{\"keyA\":\"valueA\"}")
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testUITestResponse_WithGenericDelayedResponse_ShouldResultInitializedStubServerResponse() {
		
		UITestResponse()
			.withDelay(2.0)
			.send(to: ".*")
		
		UITestServer.start()
		
		let expect = expectation(description: "\(#function)")
		let time = CACurrentMediaTime()
			
		URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
			XCTAssertGreaterThan(CACurrentMediaTime(), time + 2)
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testUITestResponse_WithDefaultResponse_ShouldResultDefaultResponseForAnyOtherCall() {
		
		UITestResponse()
			.withStatusCode(201)
			.send(to: "google.com")
		
		UITestServer.start(defaultResponse: UITestResponse().withStatusCode(203))
		
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else { return }
			XCTAssertEqual(httpResponse.statusCode, 201)
			URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://github.com")!)) { data, response, error in
				guard let httpResponse = response as? HTTPURLResponse else { return }
				XCTAssertEqual(httpResponse.statusCode, 203)
				expect.fulfill()
				}.resume()
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testUITestServer_WithStopFunction_ShouldStopRunning() {
		UITestResponse()
			.withStatusCode(203)
			.send(to: ".*")
		
		UITestServer.start()
		UITestServer.stop()
		
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else { return }
			XCTAssertNotEqual(httpResponse.statusCode, 203)
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testUITestResponse_WithValidResponseStates_ShouldReturnResponsesPerState() {
		UITestResponse()
			.withStatusCode(203)
			.willSetStateTo("state # 1")
			.send(to: ".*")
		
		UITestResponse()
			.whenStateIs("state # 2")
			.withStatusCode(205)
			.willSetStateTo("state # 3")
			.send(to: ".*")
		
		UITestResponse()
			.whenStateIs("state # 4")
			.withStatusCode(210)
			.willSetStateTo("state # 5")
			.send(to: ".*")
		
		UITestResponse()
			.whenStateIs("state # 1")
			.withStatusCode(204)
			.willSetStateTo("state # 2")
			.send(to: ".*")
		
		UITestServer.start()
		
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else { return }
			XCTAssertEqual(httpResponse.statusCode, 203)
			
			URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
				guard let httpResponse = response as? HTTPURLResponse else { return }
				XCTAssertEqual(httpResponse.statusCode, 204)
				
				URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
					guard let httpResponse = response as? HTTPURLResponse else { return }
					XCTAssertEqual(httpResponse.statusCode, 205)
					expect.fulfill()
					}.resume()
				
				}.resume()
			
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testUITestResponse_WithIncorrectResponsesStates_ShouldNotFindState2AndReturn404() {
		UITestResponse()
			.withStatusCode(203)
			.willSetStateTo("state # 1")
			.send(to: ".*")
		
		UITestResponse()
			.whenStateIs("state # 4")
			.withStatusCode(210)
			.willSetStateTo("state # 5")
			.send(to: ".*")
		
		UITestResponse()
			.whenStateIs("state # 1")
			.withStatusCode(204)
			.willSetStateTo("state # 2")
			.send(to: ".*")
		
		UITestServer.start()
		
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else { return }
			XCTAssertEqual(httpResponse.statusCode, 203)
			
			URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
				guard let httpResponse = response as? HTTPURLResponse else { return }
				XCTAssertEqual(httpResponse.statusCode, 204)
				
				URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
					guard let httpResponse = response as? HTTPURLResponse else { return }
					XCTAssertEqual(httpResponse.statusCode, 404)
					expect.fulfill()
					}.resume()
				
				}.resume()
			
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testUITestResponse_WithNoEnvironmentInfo_ShouldFailtToStart() {
		UITestServer.stop()
		UITestServer.responses = []
		UITestServer.start()
		XCTAssertNil(StubServer.instance)
	}
	
	func testUITestServer_WithVeryLargeData_ShouldParseCorrectly() {
		
		let body = "{\"data\":\"\(String.random(length: 100000))\"}"
		
		UITestResponse()
			.withBody(body.data(using: .utf8))
			.send(to: ".*")
		
		UITestServer.start()
		
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
			XCTAssertEqual(String(data: data!, encoding: .utf8), body)
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testUITestServer_WithImageData_ShouldParseCorrectly() {
		
		let bundle = Bundle(for: type(of: self))
		
		UITestResponse(filename: "mock", ofType: "png", bundle: bundle)
			.send(to: ".*")
		
		UITestServer.start()
		
		let expect = expectation(description: "\(#function)")
		
		URLSession.shared.dataTask(with: URLRequest(url: .google)) { data, response, error in
			let path = bundle.path(forResource: "mock", ofType: "png")!
			let imageData = try! Data(contentsOf: URL(fileURLWithPath: path))
			XCTAssertEqual(data, imageData)
			expect.fulfill()
			}.resume()
		
		wait(for: [expect], timeout: 5.0)
	}
	
	func testUITestServer_WithResetAll_ShouldClearAllResponses() {
		UITestResponse().withStatusCode(201).send(to: ".*")
		UITestServer.start()
		UITestServer.resetAll()
		XCTAssertTrue(UITestServer.responses.isEmpty)
		UITestServer.stop()
		
		UITestResponse().withStatusCode(201).send(to: ".*")
		UITestServer.resetAll()
		UITestServer.start()
		XCTAssertTrue(UITestServer.responses.isEmpty)
		UITestServer.stop()
		
		UITestServer.resetAll()
		UITestResponse().withStatusCode(201).send(to: ".*")
		UITestServer.start()
		XCTAssertFalse(UITestServer.responses.isEmpty)
		UITestServer.stop()
	}
	
// MARK: - Overridden Methods
	
	override func setUp() {
		UITestServer.resetAll()
	}
}
