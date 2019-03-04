/*
 *	UITestResponse.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation

// MARK: - Type -

public final class UITestResponse : StubResponse {
	
// MARK: - Properties
	
	var pattern: String?
	var state: String?
	var stateTo: String?
	
// MARK: - Constructors
	
	convenience init(infoJSON: [String : Any]) {
		self.init()
		
		if let json = infoJSON["body"] as? [String : Any] {
			body = try? JSONSerialization.data(withJSONObject: json)
		} else if let string = infoJSON["body"] as? String {
			body = string.data(using: .utf8)
		}
		
		if let newStatusCode = infoJSON["statusCode"] as? Int {
			statusCode = newStatusCode
		}
		
		if let newDelay = infoJSON["delay"] as? Double {
			delay = newDelay
		}
		
		if let newHeaders = infoJSON["headers"] as? [String : String] {
			headers = newHeaders
		} else {
			headers = ["Content-Type" : "application/json"]
		}
		
		state = infoJSON["state"] as? String
		stateTo = infoJSON["stateTo"] as? String
		pattern = infoJSON["pattern"] as? String
	}

// MARK: - Protected Methods
	
	private func bodyContent(with data: Data) -> Any {
		guard let content = try? JSONSerialization.jsonObject(with: data) else {
			return String(data: data, encoding: .utf8) ?? ""
		}
		
		return content
	}
	
// MARK: - Exposed Methods
	
	public func send(to endPoint: String) {
		
		var infoJSON = [String : Any]()
		
		if let validBody = body {
			infoJSON["body"] = bodyContent(with: validBody)
		}
		
		infoJSON["statusCode"] = statusCode
		infoJSON["delay"] = delay
		infoJSON["headers"] = headers
		infoJSON["state"] = state
		infoJSON["stateTo"] = stateTo
		infoJSON["pattern"] = endPoint
		
		UITestServer.environment.append(infoJSON)
	}
	
	public func whenStateIs(_ startingState: String) -> Self {
		state = startingState
		return self
	}
	
	public func willSetStateTo(_ finishingState: String) -> Self {
		stateTo = finishingState
		return self
	}
}
