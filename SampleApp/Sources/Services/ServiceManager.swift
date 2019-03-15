/*
 *	ServiceManager.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/9/19.
 *	Copyright 2019. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

fileprivate extension String {
	static let baseURL = "https://randomuser.me/api/?format=json"
}

// MARK: - Type -

class ServiceManager {
	
// MARK: - Properties

	static let shared = ServiceManager()

// MARK: - Constructors

	private init() { }
	
// MARK: - Protected Methods
	
	func loadRandomUser(completion: @escaping (User?, Error?) -> Void) {
		
		guard let url = URL(string: .baseURL) else {
			completion (nil, nil)
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			
			guard let validData = data,
				(response as? HTTPURLResponse)?.statusCode == 200,
				let response = try? JSONDecoder().decode(UsersResults.self, from: validData) else {
				completion (nil, error)
				return
			}
			
			completion(response.results.first, nil)
		}
		
		task.resume()
	}
}
