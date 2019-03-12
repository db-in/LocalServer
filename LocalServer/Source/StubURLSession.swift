/*
 *	StubURLSession.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/2/19.
 *	Copyright 2019. All rights reserved.
 */

import UIKit

// MARK: - Definitions -

private var exchanged = false

func exchangeOnce() {
	if !exchanged {
		exchanged = true
		
		URLSession.exchange()
		URLSessionConfiguration.exchange()
		
		#if os(iOS)
		iOSPlatformExchange()
		#endif
	}
}

// MARK: - Extension - URLSession

extension URLSession : Exchangeable {
	
	@objc private class var stubShared: URLSession {
		
		if StubServer.instance != nil {
			return URLSession(configuration: .default)
		}
		
		return URLSession.stubShared
	}
	
	static func exchange() {
		exchangeClass(#selector(getter: shared), #selector(getter: stubShared))
	}
}

// MARK: - Extension - URLSessionConfiguration

extension URLSessionConfiguration : Exchangeable {
	
	private func updated() -> Self {
		if StubServer.instance != nil {
			protocolClasses = [StubURLHTTPProtocol.self]
		}
		
		return self
	}
	
	@objc private class var stubDefault: URLSessionConfiguration {
		return URLSessionConfiguration.stubDefault.updated()
	}
	
	@objc private class var stubEphemeral: URLSessionConfiguration {
		return URLSessionConfiguration.stubEphemeral.updated()
	}
	
	static func exchange() {
		exchangeClass(#selector(getter: `default`), #selector(getter: stubDefault))
		exchangeClass(#selector(getter: ephemeral), #selector(getter: stubEphemeral))
	}
}
