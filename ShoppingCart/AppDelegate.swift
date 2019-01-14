//
//  AppDelegate.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/9/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

/* debug flags */

/// if true, delete all items on startup
fileprivate let DELETE_ON_START = false


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if DELETE_ON_START == true {
            CoreDataManager.deleteAll()
        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // save data somewhere(?)
    }


}

