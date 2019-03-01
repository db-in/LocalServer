/*
 *	StubServer.swift
 *	EKiPhone
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

public enum HTTPMethod : String, CaseIterable {
	case GET
	case POST
	case DELETE
	case HEAD
	case PUT
	case PATCH
	case TRACE
	case CONNECT
	case OPTIONS
}

public typealias RouteHandler = (_: URLRequest, _: [String: String]) -> StubResponse

public protocol LocalServerDelegate {
	func responseForURLRequest(_ urlRequest: URLRequest) -> StubResponse
}

fileprivate extension String {
	
	fileprivate func decodedURLString() -> String? {
		return replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? self
	}
	
	fileprivate func urlParameters() -> [String: String] {
		
		guard let string = decodedURLString() else { return [:] }
		
		var parameters = [String: String]()
		
		for keyValueString in string.components(separatedBy: "&") {
			let pair = keyValueString.components(separatedBy: "=")
			let value = pair.count == 2 ? pair[1] : ""
			parameters[pair[0]] = value
		}
		
		return parameters
	}
}

// MARK: - Type -

public class StubServer : LocalServerDelegate {
	
// MARK: - Properties
	
	public static var instance: LocalServerDelegate? {
		didSet {
			URLSession.exchangeOnce()
		}
	}
	
	public var defaultResponse = StubResponse().withStatusCode(404)

// MARK: - Constructors
	
	public init() { }
	
// MARK: - Protected Methods
	
	fileprivate var routes = [HTTPMethod : Router]()
	
	fileprivate func addRoute(_ method: HTTPMethod, url: String, handler: @escaping RouteHandler) {
		
		let router = routes[method, default: Router()]
		
		router.addRoute(url, handler: handler)
		routes[method] = router
	}
	
// MARK: - Exposed Methods
	
	public func responseForURLRequest(_ urlRequest: URLRequest) -> StubResponse {
		
		if let urlRequestMethod = urlRequest.httpMethod,
			let method = HTTPMethod(rawValue: urlRequestMethod),
			let router = routes[method],
			let response = router.route(urlRequest) {
			return response
		} else {
			return defaultResponse
		}
	}
	
	public func set(_ methods: [HTTPMethod], url: String, handler: @escaping RouteHandler) {
		methods.forEach {
			addRoute($0, url: url, handler: handler)
		}
	}
}

fileprivate class Router {
	
	fileprivate struct Route {
		
		var pattern: String
		var handler: RouteHandler
		
		func matchesRoute(_ url: URL) -> Bool {
			return url.absoluteString.contains(pattern) ||
				url.absoluteString.range(of: pattern, options: .regularExpression) != nil
		}
	}
	
// MARK: - Properties
	
	fileprivate var routes: [Route] = []
	
// MARK: - Protected Methods
	
	fileprivate func route(_ urlRequest: URLRequest) -> StubResponse? {
		
		let url = urlRequest.url!
		let queryParams = url.query?.urlParameters() ?? [String: String]()
		let fragmentParams = url.fragment?.urlParameters() ?? [String: String]()
		
		for route in routes {
			if route.matchesRoute(url) {
				let allParameters = queryParams.merging(fragmentParams) { (current, _) in current }
				return route.handler(urlRequest, allParameters)
			}
		}
		
		return nil
	}
	
	fileprivate func addRoute(_ pattern: String, handler: @escaping RouteHandler) {
		routes.append(Route(pattern: pattern, handler: handler))
	}
	
	fileprivate func removeRoute(_ pattern: String) {
		routes = routes.filter { $0.pattern != pattern }
	}
	
	fileprivate func removeAllRoutes() {
		routes.removeAll(keepingCapacity: false)
	}
}
