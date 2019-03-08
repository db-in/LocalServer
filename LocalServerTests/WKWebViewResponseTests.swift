/*
 *	WKWebViewResponseTests.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 1/19/19.
 *	Copyright 2019. All rights reserved.
 */

import XCTest
import WebKit
@testable import LocalServer

// MARK: - Definitions -

// MARK: - Type -

class WKWebViewResponseTests : XCTestCase {
	
	var expect: XCTestExpectation?
	var currentURL: String!
	var actionPolicy: WKNavigationActionPolicy!
	
	func testUITestResponse_WithWKWebViewLoadingMatchingURL_ShouldReturnMockWebView() {
		
		let bundle = Bundle.init(for: type(of: self))
		let url = bundle.url(forResource: "mock", withExtension: "html")!
		let html = try! String(contentsOf: url)
		
		UITestResponse()
			.withBody(html.data(using: .utf8))
			.send(to: "httpstat")
		
		UITestServer.start()
		
		expect = expectation(description: "\(#function)")
		currentURL = "https://httpstat.us/200?sleep=5000000"
		actionPolicy = .allow
		
		let webView = WKWebView()
		webView.load(URLRequest(url: URL(string: currentURL)!))
		webView.navigationDelegate = self
		
		wait(for: [expect!], timeout: 5.0)
	}
	
	func testUITestResponse_WithWKWebViewLoadingNotMatchingURL_ShouldReturnDefaultResponse() {
		
		let bundle = Bundle.init(for: type(of: self))
		let url = bundle.url(forResource: "mock", withExtension: "html")!
		let html = try! String(contentsOf: url)
		
		UITestResponse()
			.withBody(html.data(using: .utf8))
			.send(to: "foo")
		
		UITestServer.start()
		
		expect = expectation(description: "\(#function)")
		currentURL = "https://httpstat.us/200?sleep=5000000"
		actionPolicy = .cancel
		
		let webView = WKWebView()
		webView.load(URLRequest(url: URL(string: currentURL)!))
		webView.navigationDelegate = self
		
		wait(for: [expect!], timeout: 5.0)
	}
	
	override func tearDown() {
		UITestServer.resetAll()
		UITestServer.stop()
	}
}

extension WKWebViewResponseTests : WKNavigationDelegate {
	
	func webView(_ webView: WKWebView,
				 decidePolicyFor navigationAction: WKNavigationAction,
				 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		XCTAssertEqual(navigationAction.request.url?.absoluteString, currentURL)
		if actionPolicy == .cancel {
			expect?.fulfill()
		}
		decisionHandler(actionPolicy)
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		expect?.fulfill()
	}
}
