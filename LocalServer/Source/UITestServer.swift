/*
 *	UITestServer.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

fileprivate extension UITestState {

	static func setResponse(with json: [String : Any]) {
		setResponse(UITestResponse(json: json))
	}
	
	static func setRoutes(for server: StubServer) {
		responses.forEach { url, response in
			server.route(HTTPMethod.allCases, url: url) { _,_ in response.currentStateResponse() }
		}
	}
}

// MARK: - Type -

/// This is the base for the UITest Local Server and it works in conjunction with `UITestResponse`
/// It's able to provide a bridge between UITest and the main application.
///
/// `UITestServer` is able to mock Stateful and Stateless behaviors. By default it will be
/// Stateless. Each response with a different endPoint pattern defines a new state chain if needed.
///
/// * Basics: http://orca.st.usm.edu/~seyfarth/network_pgm/net-6-3-3.html
/// * Concept: https://en.wikipedia.org/wiki/State_(computer_science)
public struct UITestServer {

// MARK: - Properties
	
	private static var environmentString: String {
		return ProcessInfo().environment[environmentKey] ?? environmentInfo
	}
	
	static var responses = [[String : Any]]()
	
	/// The key used by the `UITestServer` inside the `ProcessInfo().environment`.
	public static let environmentKey = "LocalServer.ProcessInfo.Environment"
	
	/// The compressed string for `ProcessInfo().environment`.
	public static var environmentInfo: String {
		
		guard let jsonData = try? JSONSerialization.data(withJSONObject: responses),
			let data = jsonData.deflate() else {
				return ""
		}
		
		return data.base64EncodedString()
	}

// MARK: - Exposed Methods
	
	/// Starts this server. As the `UITestServer` work as a one-way bridge between UITest target
	/// and the main application target, any changes to the responses from the UITest target
	/// will not take effect until the next application relaunch.
	///
	/// - Parameter defaultResponse: Defines the default response in cases an endPoint is hit
	/// 	and no response is provided. By default it's an empty response with 200 HTTP status.
	public static func start(defaultResponse: StubResponse = StubResponse().withStatusCode(200)) {
		let server = StubServer()
		server.defaultResponse = defaultResponse
		
		guard let data = Data(base64Encoded: environmentString),
			let jsonData = data.inflate(),
			let json = try? JSONSerialization.jsonObject(with: jsonData),
			let responses = json as? [[String : Any]],
			!responses.isEmpty else {
				return
		}
		
		responses.forEach(UITestState.setResponse)
		UITestState.setRoutes(for: server)
		StubServer.instance = server
	}
	
	/// Stops the server temporarily and keeps all its current responses and states.
	public static func stop() {
		StubServer.instance = nil
	}
	
	/// Resets all the current responses and state chain inside this server.
	public static func resetAll() {
		UITestServer.responses = []
		UITestState.responses = [:]
	}
}
