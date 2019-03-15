/*
 *	Router.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/8/19.
 *	Copyright 2019. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

fileprivate extension URL {
	
	var queryItemsDictionary: [String: String] {
		
		var dictionary = [String: String]()
		let items = URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems
		
		items?.forEach { dictionary[$0.name] = $0.value }
		
		return dictionary
	}
}

fileprivate struct Route {
	
	var pattern: String
	var handler: RouteHandler
	
	func matchesRoute(_ url: URL) -> Bool {
		let string = url.absoluteString
		
		return string.contains(pattern) || string.range(of: pattern, options: .regularExpression) != nil
	}
}

// MARK: - Type -

class Router {

// MARK: - Properties
	
	private var routes: [Route] = []

// MARK: - Constructors

// MARK: - Protected Methods
	
	func route(_ urlRequest: URLRequest) -> StubResponse? {
		
		guard let url = urlRequest.url else { return nil }
		let route = routes.first { $0.matchesRoute(url) }
		
		return route?.handler(urlRequest, url.queryItemsDictionary)
	}
	
	func addRoute(_ pattern: String, handler: @escaping RouteHandler) {
		routes.append(Route(pattern: pattern, handler: handler))
	}

// MARK: - Exposed Methods

// MARK: - Overridden Methods
}
