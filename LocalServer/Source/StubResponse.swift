/*
 *	StubResponse.swift
 *	EKiPhone
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation

// MARK: - Type -

open class StubResponse {

// MARK: - Properties

	var statusCode: Int = 200
	var delay: Double = 0.0
	var body: Data?
	var headers = [String: String]()
	
// MARK: - Constructors

	public init() { }

	public init(data: Data) {
		body = data
	}

	public init(json: [String : Any]) {
		body = try? JSONSerialization.data(withJSONObject: json)
	}
	
	public init(string: String) {
		body = string.data(using: .utf8)
	}

	public init(filename: String, ofType type: String, bundle: Bundle = .main) {
		if let filePath = bundle.path(forResource: filename, ofType: type) {
			body = try? Data(contentsOf: URL(fileURLWithPath: filePath))
		}
	}
	
// MARK: - Exposed Methods

	open func withDelay(_ time: Double) -> Self {
		delay = time
		return self
	}
	
	open func withBody(_ string: String) -> Self {
		body = string.data(using: .utf8)
		return self
	}

	open func withStatusCode(_ code: Int) -> Self {
		statusCode = code
		return self
	}

	open func withHeaders(_ httpHeaders: [String: String]) -> Self {
		for (key, value) in httpHeaders { headers[key] = value }
		return self
	}
}
