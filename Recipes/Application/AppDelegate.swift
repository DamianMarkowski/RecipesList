//
//  AppDelegate.swift
//  Recipes
//
//  Created by Damian Markowski on 21.02.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setInitialViewController()
        return true
    }
    
    private func setInitialViewController(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: MainViewController())
        self.window?.rootViewController = navigationController
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
    }
}

