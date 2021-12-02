/*
 *	StubResponse.swift
 *	EKiPhone
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation

// MARK: - Type -

/// `StubResponse` is the base response to simulate `URLResponses`.
/// It defines the HTTP Status code, the Responder Header and Body.
/// It can also define a delay in seconds, simulating delayed server responses.
open class StubResponse {

// MARK: - Properties

	var delay: Double = 0.0
	var statusCode: Int = 200
	var headers = [String : String]()
	var body: Data?
	var error: Error?
	
// MARK: - Constructors

	/// Base initializer. Keep all the default properties' values.
	public init() { }

	/// Initializes the response with a given data for the body.
	///
	/// - Parameter data: A Data object to be used as is in the body.
	public init(data: Data) {
		body = data
	}

	/// Initializes the response with a given JSON as the body data.
	///
	/// - Parameter json: A Dictionary using JSON standards.
	public init(json: [String : Any]) {
		body = try? JSONSerialization.data(withJSONObject: json)
	}
	
	/// Initializes the response with a given UTF8 string as the body data.
	///
	/// - Parameter string: A String in UTF8 format.
	public init(string: String) {
		body = string.data(using: .utf8)
	}
	
	/// Initializes the response with the content of a given file.
	///
	/// - Parameters:
	///   - filename: A String with the file name only, no extension.
	///   - type: A string with the file extension only.
	///   - bundle: The bundle where the file is localed. By default it's `.main`.
	public init(filename: String, ofType type: String, bundle: Bundle = .main) {
		if let filePath = bundle.path(forResource: filename, ofType: type) {
			body = try? Data(contentsOf: URL(fileURLWithPath: filePath))
		}
	}
	
	/// Initializes the response with a real request being performed.
	///
	/// - Parameter request: URLRequest
	init(withReal request: URLRequest) {
		let semaphore = DispatchSemaphore(value: 0)
		
		URLSession.realShared.dataTask(with: request) {(data, response, error) in
			
			if let httpResponse = response as? HTTPURLResponse {
				self.statusCode = httpResponse.statusCode
				self.headers = (httpResponse.allHeaderFields as? [String : String]) ?? self.headers
			}
			
			self.body = data
			self.error = error
			
			semaphore.signal()
		}.resume()
		semaphore.wait()
	}
	
// MARK: - Exposed Methods

	/// Returns the same response object with a new delay. The delay can be used to simulate
	/// a slow network response.
	///
	/// - Parameter time: A Double representing the delay in seconds.
	/// - Returns: The same response with a new delay.
	open func withDelay(_ time: Double) -> Self {
		delay = time
		return self
	}
	
	/// Returns the same response object with a new status code.
	///
	/// - Parameter code: A String as the new status code.
	/// - Returns: The same response with a new status code.
	open func withStatusCode(_ code: Int) -> Self {
		statusCode = code
		return self
	}
	
	/// Returns the same response object with a new headers.
	///
	/// - Parameter httpHeaders: A Dictionary with the new headers.
	/// - Returns: The same response with a header.
	open func withHeaders(_ httpHeaders: [String: String]) -> Self {
		for (key, value) in httpHeaders { headers[key] = value }
		return self
	}
	
	/// Returns the same response object with a new body.
	///
	/// - Parameter data: A Data as the new body.
	/// - Returns: The same response with a new body.
	open func withBody(_ data: Data?) -> Self {
		body = data
		return self
	}
	
	/// Returns the same response object with a new error.
	///
	/// - Parameter error: The error to be returned on the network call.
	/// - Returns: The same response with a new error.
	open func withError(_ newError: Error?) -> Self {
		error = newError
		return self
	}
	
	/// This function automatically creates and prepares a response in the internal shared
	/// `StubServer`. It will automatically switch any previous defined server in order to
	/// prioritize the internal shared server.
	///
	///	The response will be triggerred to any HTTP method.
	///
	/// - Parameter endPoint: Defines the endPoint pattern matching for this response.
	open func send(to endPoint: String) {
		StubServer.shared.route(HTTPMethod.allCases, url: endPoint) { _,_ in self }
		StubServer.instance = StubServer.shared
	}
}
