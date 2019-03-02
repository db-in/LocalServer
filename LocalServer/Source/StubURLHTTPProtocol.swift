/*
 *	StubURLHTTPProtocol.swift
 *	EKiPhone
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

// MARK: - Type -

class StubURLHTTPProtocol : URLProtocol {
	
// MARK: - Properties

	var stopped: Bool = false

// MARK: - Protected Methods
	
	private func delay(_ delay: Double, closure: @escaping () -> Void) {
		let interval = Int64(delay * Double(NSEC_PER_SEC))
		let time = DispatchTime.now() + Double(interval) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: time, execute: closure)
	}
	
// MARK: - Overridden Methods

	override class func canInit(with request: URLRequest) -> Bool {
		
		guard let scheme = request.url?.scheme else { return false }
		return ["http", "https"].contains(scheme)
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
				
				guard !self.stopped else { return }
				
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
