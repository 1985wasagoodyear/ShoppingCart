//
//  ProductTabBarController.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/11/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class ProductTabBarController: UITabBarController {
    
    private var coreData: CoreDataManager!
    private var service: ServiceManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coreData = CoreDataManager()
        self.service = ServiceManager(manager: coreData)
        
        let listVC = self.viewControllers?.first as! ShoppingListViewController
        listVC.setupViewModel(self.coreData, self.service)
        let tableVC = self.viewControllers?.last as! ShoppingCartViewController
        tableVC.setupViewModel(self.coreData, self.service)
    }
}
