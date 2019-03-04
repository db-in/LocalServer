/*
 *	StubWKWebView.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 1/20/19.
 *	Copyright 2019. All rights reserved.
 */

#if os(iOS)
import WebKit

// MARK: - Type -

@available(iOS 8.0, *)
func iOSPlatformExchange() {
	WKWebView.exchange()
}

// MARK: - Extension - WKWebView

@available(iOS 8.0, *)
extension WKWebView : Exchangeable {
	
	@objc func stubLoad(_ request: URLRequest) -> WKNavigation? {
		
		if let body = StubServer.instance?.responseForURLRequest(request).body,
			let bodyString = String(data: body, encoding: .utf8) {
			return loadHTMLString(bodyString, baseURL: request.url)
		}
		
		return stubLoad(request)
	}
	
	static func exchange() {
		exchangeInstance(#selector(load(_:)), #selector(stubLoad))
	}
}
#endif
