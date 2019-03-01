/*
 *	TestExtensions.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/1/19.
 *	Copyright 2019 Emirates Group. All rights reserved.
 */

import Foundation

// MARK: - Type -

extension String {

// MARK: - Exposed Methods

	static func random(length: Int) -> String {
		let largeData = [Character]("abcdefghijklmnopqrstuvxzwy")
		let characters = (0...length).compactMap { _ in largeData.randomElement() }
		return String(characters)
	}
}
