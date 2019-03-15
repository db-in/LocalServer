//
//  AppDelegate.swift
//  SampleApp
//
//  Created by DINEY B ALVES on 3/9/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit
import LocalServer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

	var window: UIWindow?
	
	private func setAppStateForUITestsIfRequired() {
		
		guard ProcessInfo().arguments.contains("-UITests") else { return }
		
		UITestServer.resetAll()
		UITestServer.start()
	}

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		setAppStateForUITestsIfRequired()
		
		let split = window?.rootViewController as? UISplitViewController
		let navigation = split?.viewControllers.last as? UINavigationController
		navigation?.topViewController?.navigationItem.leftBarButtonItem = split?.displayModeButtonItem
		split?.delegate = self
		
		return true
	}

// MARK: - Split view

	func splitViewController(_ splitViewController: UISplitViewController,
							 collapseSecondary secondaryViewController:UIViewController,
							 onto primaryViewController:UIViewController) -> Bool {
		
	    guard let secondaryAsNavController = secondaryViewController as? UINavigationController,
			let topAsDetailController = secondaryAsNavController.topViewController as? UserDetailViewController else {
				return false
		}
		
	    return topAsDetailController.detailItem == nil
	}
}
