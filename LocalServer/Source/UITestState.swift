/*
 *	UITestState.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 12/23/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation

// MARK: - Type -

class UITestState {

// MARK: - Properties

	var pattern: String
	var currentState = ""
	var states = [String : UITestResponse]()
	static var responses = [String : UITestState]()
	
// MARK: - Constructors

	init(url: String) {
		pattern = url
	}
	
// MARK: - Protected Methods
	
	func addResponse(_ response: UITestResponse) {
		states[response.state ?? ""] = response
	}
	
	func currentStateResponse() -> UITestResponse {
		let response = states[currentState]
		currentState = response?.stateTo ?? ""
		return response ?? UITestResponse().withStatusCode(404)
	}
	
	static func setResponse(_ response: UITestResponse) {
		if let url = response.pattern {
			if responses[url] == nil {
				responses[url] = UITestState(url: url)
			}
			
			if let state = responses[url] {
				state.addResponse(response)
			}
		}
	}
}
