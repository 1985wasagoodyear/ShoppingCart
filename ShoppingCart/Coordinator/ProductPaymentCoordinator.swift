//
//  ProductPaymentCoordinator.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 3/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

final class ProductPaymentCoordinator: Coordinator {
    
    private var rootVC: UIViewController
    private var parentCoordinator: Coordinator
    weak var paymentDelegate: PaymentDelegate!
    
    private var coreData: CoreDataManager
    private var service: ServiceManager
    
    init(rootVC: UIViewController, parent: Coordinator,
         coreData: CoreDataManager, service: ServiceManager) {
        self.rootVC = rootVC
        self.parentCoordinator = parent
        self.coreData = coreData
        self.service = service
    }
    
    override func start() {
        let vc = UIStoryboard.getFromMain("PaymentViewController") as! PaymentViewController
        let vm = ProductsViewModel(manager: coreData, service: service)
        vc.setViewModel(vm)
        vc.paymentDelegate = self
        rootVC.present(vc, animated: true, completion: nil)
    }
    
    override func finish() {
        parentCoordinator.removeChildCoordinator(self)
    }
    
}

extension ProductPaymentCoordinator: PaymentDelegate {
    
    func finishPaymentFlow(sender: Any? = nil) {
        self.paymentDelegate.finishPaymentFlow(sender: sender)
        finish()
    }
    
    func cancelPaymentFlow(sender: Any? = nil) {
        self.paymentDelegate.cancelPaymentFlow(sender: sender)
        finish()
    }
}

