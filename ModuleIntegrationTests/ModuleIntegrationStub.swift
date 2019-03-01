/*
 *	StubServer.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 11/27/18.
 *	Copyright 2018. All rights reserved.
 */

import XCTest
import LocalServer

// MARK: - Definitions -

// MARK: - Type -

public class TestLocalServer {
	
// MARK: - Exposed Methods
	
	static public func startLocalServer() {
		let server = StubServer()
		
		server.set([.GET], url: ".*") { (request, parameters) -> StubResponse in
			return StubResponse().withStatusCode(999)
		}
		
		StubServer.instance = server
	}
	
	static public func stopLocalServer() {
		StubServer.instance = nil
	}
}
