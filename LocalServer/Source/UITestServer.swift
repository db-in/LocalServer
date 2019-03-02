/*
 *	UITestServer.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation

// MARK: - Type -

public struct UITestServer {

// MARK: - Properties
	
	private static var environmentString: String {
		return ProcessInfo().environment[environmentKey] ?? environmentInfo
	}
	
	static var environment = [[String : Any]]()
	
	public static let environmentKey = "LocalServer.ProcessInfo.Environment"
	
	public static var environmentInfo: String {
		guard let jsonData = try? JSONSerialization.data(withJSONObject: environment),
			let data = jsonData.deflate() else { return "" }
		return data.base64EncodedString()
	}

// MARK: - Exposed Methods
	
	public static func start(defaultResponse: StubResponse = StubResponse().withStatusCode(200)) {
		let server = StubServer()
		server.defaultResponse = defaultResponse
		
		guard let data = Data(base64Encoded: environmentString),
			let jsonData = data.inflate(),
			let json = try? JSONSerialization.jsonObject(with: jsonData) as? [[String : Any]],
			json?.isEmpty == false else {
				return
		}
		
		json?.forEach { json in
			let response = UITestResponse(infoJSON: json)
			UITestState.setResponse(response)
		}
		
		UITestState.responses.forEach { url, response in
			server.route(HTTPMethod.allCases, url: url) { _,_  in response.currentStateResponse() }
		}
		
		StubServer.instance = server
	}
	
	public static func stop() {
		StubServer.instance = nil
	}
	
	public static func resetAll() {
		UITestServer.environment = []
		UITestState.responses = [:]
	}
}
