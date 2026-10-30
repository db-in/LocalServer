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
	var expectedMethod: String?
	
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
	
	func testStubServer_WithWKWebViewLoadingUnmatchedURLAndRealRequestsAllowed_ShouldLoadOriginalRequest() {
		
		let server = StubServer(allowRealRequests: true)
		server.route([.POST], url: "httpbin") { _, _ in StubResponse() }
		StubServer.instance = server
		
		expect = expectation(description: "\(#function)")
		currentURL = "https://httpstat.us/200"
		actionPolicy = .cancel
		expectedMethod = "POST"
		
		var request = URLRequest(url: URL(string: currentURL)!)
		request.httpMethod = "POST"
		
		let webView = WKWebView()
		webView.navigationDelegate = self
		webView.load(request)
		
		wait(for: [expect!], timeout: 5.0)
	}
	
	override func tearDown() {
		expectedMethod = nil
		UITestServer.resetAll()
		UITestServer.stop()
	}
}

extension WKWebViewResponseTests : WKNavigationDelegate {
	
	func webView(_ webView: WKWebView,
				 decidePolicyFor navigationAction: WKNavigationAction,
				 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		XCTAssertEqual(navigationAction.request.url?.absoluteString, currentURL)
		if let expectedMethod {
			XCTAssertEqual(navigationAction.request.httpMethod, expectedMethod)
		}
		if actionPolicy == .cancel {
			expect?.fulfill()
		}
		decisionHandler(actionPolicy)
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		expect?.fulfill()
	}
}
