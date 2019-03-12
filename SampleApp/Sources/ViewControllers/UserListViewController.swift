//
//  UserListViewController.swift
//  SampleApp
//
//  Created by DINEY B ALVES on 3/9/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

extension IndexPath {
	
	static let zero = IndexPath(row: 0, section: 0)
}

class UserListViewController: UITableViewController {

	private var objects = [User]()
	
	private func showErrorAlert() {
		
		let alert = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .cancel)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}

	private lazy var loadingIndicator: UIActivityIndicatorView = {
		
		let activityIndicator = UIActivityIndicatorView(style: .gray)
		activityIndicator.center = view.center
		view.addSubview(activityIndicator)
		return activityIndicator
	}()
	
	private func insertUser(_ user: User?) {

		loadingIndicator.stopAnimating()
		
		guard let validUser = user else {
			showErrorAlert()
			return
		}
		
		objects.insert(validUser, at: 0)
		tableView.insertRows(at: [.zero], with: .automatic)
	}

	@objc private func insertNewObject() {
		
		loadingIndicator.startAnimating()
		
		ServiceManager.shared.loadRandomUser { [weak self] (user, error) in
			DispatchQueue.main.async {
				self?.insertUser(user)
			}
		}
	}
	
	private func retrieveDetailController(from: UIViewController) -> UserDetailViewController? {
		
		guard let navigationController = from as? UINavigationController else { return nil }
		return navigationController.topViewController as? UserDetailViewController
	}

// MARK: - Overriden Methods
	
	override func viewDidLoad() {
		
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject))
		navigationItem.rightBarButtonItem = addButton
		navigationItem.leftBarButtonItem = editButtonItem
		navigationItem.rightBarButtonItem?.accessibilityIdentifier = "button.add"
		navigationItem.leftBarButtonItem?.accessibilityIdentifier = "button.edit"
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? false
		super.viewWillAppear(animated)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		guard let indexPath = tableView.indexPathForSelectedRow else { return }
		let controller = retrieveDetailController(from: segue.destination)
		controller?.detailItem = objects[indexPath.row]
		controller?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
		controller?.navigationItem.leftItemsSupplementBackButton = true
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}

	override func tableView(_ tableView: UITableView,
							cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.accessibilityIdentifier = "cell.user"
		cell.textLabel!.text = objects[indexPath.row].fullName
		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView,
							commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
		    objects.remove(at: indexPath.row)
		    tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
}
