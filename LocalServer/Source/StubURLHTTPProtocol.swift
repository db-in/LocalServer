/*
 *	StubURLHTTPProtocol.swift
 *	EKiPhone
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

private func delay(_ delay: Double, closure:@escaping ()->()) {
	DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

// MARK: - Type -

fileprivate class StubURLHTTPProtocol : URLProtocol {
	
// MARK: - Properties

	var stopped: Bool = false

// MARK: - Protected Methods
	
// MARK: - Overridden Methods

	override class func canInit(with request: URLRequest) -> Bool {
		if let scheme = request.url?.scheme {
			return ["http", "https"].index(of: scheme) != nil
		} else {
			return false
		}
	}
	
	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}
	
	override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
		return false
	}
	
	override func startLoading() {
		
		if let stubResponse = StubServer.instance?.responseForURLRequest(request) {
			delay(stubResponse.delay) {
				if self.stopped { return }
				
				let response = HTTPURLResponse(url: self.request.url!,
											   statusCode: stubResponse.statusCode,
											   httpVersion: "HTTP/1.1",
											   headerFields: stubResponse.headers)!
				
				self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
				
				if let body = stubResponse.body {
					self.client?.urlProtocol(self, didLoad: body)
				}
				
				self.client?.urlProtocolDidFinishLoading(self)
			}
		} else {
			let error = NSError(domain: "",
								code: 0,
								userInfo: [NSLocalizedDescriptionKey: "Missing response"])
			client?.urlProtocol(self, didFailWithError: error)
		}
	}
	
	override func stopLoading() {
		stopped = true
	}
}

// MARK: - Extension - URLSession

extension URLSession : Exchangeable {
	
	private static var exchanged = false
	
	@objc private class var _shared: URLSession {
		let config = URLSessionConfiguration.default
		
		if StubServer.instance != nil {
			config.protocolClasses = [StubURLHTTPProtocol.self]
			return URLSession(configuration: config)
		}
		
		return URLSession._shared
	}
	
	static func exchange() {
		exchangeClass(#selector(getter: shared), #selector(getter: _shared))
		
#if os(iOS)
		iOSPlatformExchange()
#endif
	}
	
	static func exchangeOnce() {
		if !exchanged {
			exchange()
			exchanged = true
		}
	}
}
