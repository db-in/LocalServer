/*
 *	StubResponseTests.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/1/19.
 *	Copyright 2019. All rights reserved.
 */

import XCTest
@testable import LocalServer

// MARK: - Definitions -

// MARK: - Type -

class StubResponseTests : XCTestCase {

// MARK: - Properties
	
	lazy var stringValue: String = {
		return String.random(length: 50)
	}()
	
	var jsonValue: [String : Any] {
		return ["paramA" : "valueA"]
	}
	
	var stringData: Data {
		return stringValue.data(using: .utf8)!
	}
	
// MARK: - Constructors

// MARK: - Protected Methods

// MARK: - Exposed Methods
	
	func testStubResponse_WithDefaultInitializer_ShouldCreateDefaultValues() {
		let response = StubResponse()
		
		XCTAssertEqual(response.statusCode, 200)
		XCTAssertEqual(response.delay, 0.0)
		XCTAssertEqual(response.body, nil)
		XCTAssertTrue(response.headers.isEmpty)
	}
	
	func testStubResponse_WithDataInitializer_ShouldCreateResponseBody() {
		let response = StubResponse(data: stringData)
		
		XCTAssertEqual(response.body, stringData)
	}
	
	func testStubResponse_WithJSONInitializer_ShouldCreateResponseBody() {
		let response = StubResponse(json: jsonValue)
		let jsonBody = try! JSONSerialization.jsonObject(with: response.body!) as! [String : Any]
		
		XCTAssertEqual(jsonBody.count, jsonValue.count)
		XCTAssertEqual(jsonBody["paramA"] as! String, jsonValue["paramA"] as! String)
	}
	
	func testStubResponse_WithStringInitializer_ShouldCreateResponseBody() {
		let response = StubResponse(string: stringValue)
		let stringBody = String(data: response.body!, encoding: .utf8)
		
		XCTAssertEqual(stringBody, stringValue)
	}
	
	func testStubResponse_WithFileInitializer_ShouldCreateResponseBody() {
		let bundle = Bundle(for: StubResponseTests.self)
		let response = StubResponse(filename: "mock", ofType: "json", bundle: bundle)
		let filePath = bundle.path(forResource: "mock", ofType: "json")!
		let file = try! Data(contentsOf: URL(fileURLWithPath: filePath))
		
		XCTAssertEqual(response.body?.count, file.count)
	}

// MARK: - Overridden Methods

}
