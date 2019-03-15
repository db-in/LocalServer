/*
 *	UserMock.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/10/19.
 *	Copyright 2019. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

enum UserType : String {
	case male
	case female
	
	var file: String {
		return rawValue
	}
}

extension UserType {
	
	var shortName: String {
		switch self {
		case .male:
			return "Brent Robertson"
		case .female:
			return "Crystal Reed"
		}
	}
	
	var fullName: String {
		switch self {
		case .male:
			return "Mr \(shortName)"
		case .female:
			return "Miss \(shortName)"
		}
	}
	
	var email: String {
		switch self {
		case .male:
			return "brent.robertson36@example.com"
		case .female:
			return "crystal.reed12@example.com"
		}
	}
}
