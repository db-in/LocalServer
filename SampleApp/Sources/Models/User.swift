/*
 *	User.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/9/19.
 *	Copyright 2019. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

struct UsersResults: Codable {
	
	let results: [User]
}

struct Name: Codable {
	
	let title: String
	let first: String
	let last: String
}

struct Picture: Codable {
	
	let medium: String
	
	var url: URL? {
		return URL(string: medium)
	}
}

struct User: Codable {
	
	let email: String?
	let name: Name?
	let picture: Picture?
	
	var fullName: String {
		guard let name = name else { return "" }
		return "\(name.title) \(name.first) \(name.last)".capitalized
	}
}
