//
//  AppDelegate.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/9/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        CoreDataManager.deleteAll()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // save data somewhere(?)
    }


}

