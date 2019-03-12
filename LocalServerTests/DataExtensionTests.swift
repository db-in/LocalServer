/*
 *	DataExtensionTests.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/12/19.
 *	Copyright 2019. All rights reserved.
 */

import XCTest
@testable import LocalServer

// MARK: - Definitions -

extension ClosedRange where Bound == Int {
	
	func randomStringData() -> Data {
		let data = String("abcdefghijklmnopqrstuwxyz")
		let source = compactMap { _ in data.randomElement() }
		return String(source).data(using: .utf8)!
	}
}

// MARK: - Type -

class DataExtensionTests : XCTestCase {
		
// MARK: - Exposed Methods
	
	func testDataCompression_WithDeflateRandomData_ShouldCompressData() {
		let data = (0...1000).randomStringData()
		let compressed = data.deflate()!
		
		XCTAssertLessThan(compressed.count, data.count)
	}
	
	func testDataCompression_WithInflateRandomData_ShouldDecompressAndMatchOriginalData() {
		let data = (0...1000).randomStringData()
		let compressed = data.deflate()!
		let decompressed = compressed.inflate()!
		
		XCTAssertLessThan(compressed.count, data.count)
		XCTAssertLessThan(compressed.count, decompressed.count)
		XCTAssertEqual(decompressed.count, data.count)
		XCTAssertEqual(decompressed, data)
	}
}
