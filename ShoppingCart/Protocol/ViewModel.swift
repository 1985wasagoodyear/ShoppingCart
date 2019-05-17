//
//  ViewModel.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 3/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

typealias ViewModelCallback = ()->()

protocol ViewModel: class {
    func setCallback(_ callback: @escaping ViewModelCallback)
}

protocol ListViewModel: ViewModel {
    
    var productCount: Int { get }
    var totalPrice: Double { get }
    var totalPriceString: String { get }
    
    func reload()
    func loadFromCart()
    func loadProducts(_ success: @escaping ()->(),
                      _ failure: @escaping ()->())
    
    func performPayment(_ completion: @escaping ()->())
    
    func productCount(at index: Int) -> Int
    
    func productInfo(at index: Int) -> ProductInfo
    
    func getImage(at index: Int, _ completion: @escaping (Data)->())
}
