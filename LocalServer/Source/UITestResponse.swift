/*
 *	UITestResponse.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation

fileprivate extension String {
	
	static let body = "body"
	static let statusCode = "statusCode"
	static let delay = "delay"
	static let headers = "headers"
	static let state = "state"
	static let stateTo = "stateTo"
	static let pattern = "pattern"
}

// MARK: - Type -

/// The `UITestResponse` is the base response for `UITestServer`. It contains methods to send
/// the response data to the Local Server.
/// This type also provides support to the concept of states for simulating Stateful behaviors
///
/// - Basics: http://orca.st.usm.edu/~seyfarth/network_pgm/net-6-3-3.html
/// - Concept: https://en.wikipedia.org/wiki/State_(computer_science)
///
/// The response can be tied to a initial state and be connected to a next state, creating a
/// state chain if needed.
public final class UITestResponse : StubResponse {
	
// MARK: - Properties
	
	var pattern: String?
	var state: String?
	var stateTo: String?
	
// MARK: - Constructors
	
	convenience init(infoJSON: [String : Any]) {
		self.init()
		
		if let encodedString = infoJSON[.body] as? String {
			body = Data(base64Encoded: encodedString)
		}
		
		if let newStatusCode = infoJSON[.statusCode] as? Int {
			statusCode = newStatusCode
		}
		
		if let newDelay = infoJSON[.delay] as? Double {
			delay = newDelay
		}
		
		if let newHeaders = infoJSON[.headers] as? [String : String] {
			headers = newHeaders
		}
		
		state = infoJSON[.state] as? String
		stateTo = infoJSON[.stateTo] as? String
		pattern = infoJSON[.pattern] as? String
	}
	
// MARK: - Exposed Methods
	
	/// Defines the initial state for this response. It means this response will not take
	/// effect unless its initial state is reached by some other response. When no initial state
	/// is defined it means the response will be at the root of the state chain.
	///
	/// The states are grouped by the endPoint pattern defined by `send(to:)`
	///
	/// - Parameter startingState: The state in which this response will start taking effect.
	/// - Returns: The same response object with a new initial state.
	public func whenStateIs(_ startingState: String) -> Self {
		state = startingState
		return self
	}
	
	/// Defines the output state for this response. If no end state is defined the endpoint pattern
	/// it's attached to will keep the previous state.
	///
	/// The states are grouped by the endPoint pattern defined by `send(to:)`
	///
	/// - Parameter finishingState: The state in which this response will ends at.
	/// - Returns: The same response object with a new initial state.
	public func willSetStateTo(_ finishingState: String) -> Self {
		stateTo = finishingState
		return self
	}
	
// MARK: - Overriden Methods
	
	public override func withError(_ newError: Error?) -> Self {
		assertionFailure("UITestResponse can't provide error. Use the StubResponse directly.")
		return self
	}
	
	public override func send(to endPoint: String, methods: [HTTPMethod] = HTTPMethod.allCases) {
		let infoJSON: [String : Any] = [.body : body?.base64EncodedString() as Any,
										.statusCode : statusCode,
										.delay : delay,
										.headers : headers,
										.state : state as Any,
										.stateTo : stateTo as Any,
										.pattern : endPoint]
		
		UITestServer.responses.append(infoJSON)
	}
}
