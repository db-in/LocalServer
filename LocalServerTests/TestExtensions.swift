/*
 *	TestExtensions.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/1/19.
 *	Copyright 2019 Emirates Group. All rights reserved.
 */

import Foundation

// MARK: - Extension - String

extension String {

// MARK: - Exposed Methods

	static func random(length: Int) -> String {
		let largeData = [Character]("abcdefghijklmnopqrstuvxzwy")
		let characters = (0...length).compactMap { _ in largeData.randomElement() }
		return String(characters)
	}
}

// MARK: = Extension - URL

extension URL {
	static let google = URL(string: "https://google.com")!
	static let httpbinPOST = URL(string: "https://httpbin.org/post")!
}
