/*
 *	UserMock.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/10/19.
 *	Copyright 2019 Emirates Group. All rights reserved.
 */

import UIKit

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
			return "Mr Brent Robertson"
		case .female:
			return "Miss Crystal Reed"
		}
	}
	
	var email: String {
		switch self {
		case .male:
			return "Mr Brent Robertson"
		case .female:
			return "crystal.reed12@example.com"
		}
	}
	
	
	var birthday: String {
		switch self {
		case .male:
			return ""
		case .female:
			return ""//"1948-03-05T07:17:35Z"
		}
	}
	
	
	var phone: String {
		switch self {
		case .male:
			return ""
		case .female:
			return ""//"(898)-320-5830" //"(458)-844-1317"
		}
	}
	
	
}
