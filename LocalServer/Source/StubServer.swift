/*
 *	StubServer.swift
 *	EKiPhone
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

/// The HTTP Methods as per W3C consortium standards.
/// https://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html
public enum HTTPMethod : String, CaseIterable {
	
	/// The GET method.
	case GET
	
	/// The POST method.
	case POST
	
	/// The DELETE method.
	case DELETE
	
	/// The HEAD method.
	case HEAD
	
	/// The PUT method.
	case PUT
	
	/// The PATCH method.
	case PATCH
	
	/// The TRACE method.
	case TRACE
	
	/// The CONNECT method.
	case CONNECT
	
	/// The OPTIONS method.
	case OPTIONS
}

/// The closure format containg Request and the query parameters for a given URL
public typealias RouteHandler = (_: URLRequest, _: [String: String]) -> StubResponse

/// Defines the necessary methods to become a LocalServer responder.
public protocol LocalServerDelegate {
	
	/// This function is called by the LocalServer everytime a new Request is fired by the
	/// URLSession mechanism.
	///
	/// - Parameter urlRequest: The incoming original URLRequest
	/// - Returns: A StubResponse instance representing the stub response.
	func responseForURLRequest(_ urlRequest: URLRequest) -> StubResponse
}

// MARK: - Type -

/// Defines the main Stub Server object. It can be subclassed to provide various other types
/// of local server.
public class StubServer {
	
// MARK: - Properties
	
	fileprivate var routes = [HTTPMethod : Router]()
	
	/// Current instance of any Local Server.
	public static var instance: LocalServerDelegate? {
		didSet {
			exchangeOnce()
		}
	}
	
	/// The default response for this server in case there is no given match for the response.
	public var defaultResponse = StubResponse().withStatusCode(404)

// MARK: - Constructors
	
	/// The default initializer for an empty StubServer
	public init() { }
	
// MARK: - Protected Methods
	
	fileprivate func addRoute(_ method: HTTPMethod, url: String, handler: @escaping RouteHandler) {
		
		let router = routes[method, default: Router()]
		
		router.addRoute(url, handler: handler)
		routes[method] = router
	}
	
// MARK: - Exposed Methods
	
	/// Defines a route to this server. Multiple routes can be defined this way.
	///
	/// - Parameters:
	///   - methods: The set of HTTP Method that this route will be listening to.
	///   - url: The url string pattern attached to this route. It accept regex patterns.
	///   - handler: The route handler for this listener.
	public func route(_ methods: [HTTPMethod], url: String, handler: @escaping RouteHandler) {
		methods.forEach {
			addRoute($0, url: url, handler: handler)
		}
	}
}

extension StubServer : LocalServerDelegate {
	
	/// This function is called by the LocalServer everytime a new Request is fired by the
	/// URLSession mechanism.
	///
	/// - Parameter urlRequest: The incoming original URLRequest
	/// - Returns: A StubResponse instance representing the stub response.
	public func responseForURLRequest(_ urlRequest: URLRequest) -> StubResponse {
		
		if let rawMethod = urlRequest.httpMethod,
			let method = HTTPMethod(rawValue: rawMethod),
			let router = routes[method],
			let response = router.route(urlRequest) {
			return response
		}
		
		return defaultResponse
	}
}
