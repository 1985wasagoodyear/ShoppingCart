//
//  ProductTabBarCoordinator.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 3/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

/// created by App Delegate
final class ProductTabBarCoordinator: Coordinator {
    
    var rootVC: ProductTabBarController
    
    private var coreData: CoreDataManager
    private var service: ServiceManager
    
    override init() {
        // create the first VC and populate it
        rootVC = UIStoryboard.getFromMain("ProductTabBarController") as! ProductTabBarController
        
        // create services
        coreData = CoreDataManager()
        service = ServiceManager(manager: coreData)
    }
    
    override func start() {
        // create my VCs for my tabbar
        let first = UIStoryboard.getFromMain("ShoppingListViewController") as! ShoppingListViewController
        let second = UIStoryboard.getFromMain("ShoppingCartViewController") as! ShoppingCartViewController
        second.paymentNavDelegate = self
        
        // create my VMs
        let firstVM = ProductsViewModel(manager: coreData, service: service)
        let secondVM = ProductsViewModel(manager: coreData, service: service)
        first.setViewModel(firstVM)
        second.setViewModel(secondVM)
        
        
        // assign VCs to tabbar
        rootVC.setViewControllers([first, second], animated: false)
    }
    
    override func finish() {
        print("Not implemented")
    }
    
    override func removeChildCoordinator(_ coordinator: Coordinator) {
        super.removeChildCoordinator(coordinator)
    }

}

extension ProductTabBarCoordinator: PaymentNavigationDelegate {
    func startPaymentFlow() {
        let newCoordinator = ProductPaymentCoordinator(rootVC: rootVC,
                                                       parent: self,
                                                       coreData: coreData, service: service)
        newCoordinator.paymentNavDelegate = self
        newCoordinator.start()
        addChildCoordinator(newCoordinator)
    }
    func finishPaymentFlow(sender: UIViewController) {
        rootVC.finishPaymentFlow()
        sender.dismiss(animated: true, completion: nil)
    }
    func cancelPaymentFlow(sender: UIViewController) {
        rootVC.cancelPaymentFlow()
        sender.dismiss(animated: true, completion: nil)
    }
}
