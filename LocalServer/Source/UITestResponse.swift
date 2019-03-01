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
		
		statusCode = infoJSON["statusCode"] as? Int ?? 200
		delay = infoJSON["delay"] as? Double ?? 0.0
		headers = infoJSON["headers"] as? [String : String] ?? ["Content-Type" : "application/json"]
		state = infoJSON["state"] as? String
		stateTo = infoJSON["stateTo"] as? String
		pattern = infoJSON["pattern"] as? String
	}
	
// MARK: - Exposed Methods
	
	public func send(to: String) {
		
		var infoJSON = [String : Any]()
		
		if let validBody = body {
			let jsonBody = try? JSONSerialization.jsonObject(with: validBody)
			let stringBody = String(data: validBody, encoding: .utf8) as Any
			infoJSON = ["body": jsonBody ?? stringBody]
		}
		
		infoJSON["statusCode"] = statusCode
		infoJSON["delay"] = delay
		infoJSON["headers"] = headers
		infoJSON["state"] = state
		infoJSON["stateTo"] = stateTo
		infoJSON["pattern"] = to
		
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
