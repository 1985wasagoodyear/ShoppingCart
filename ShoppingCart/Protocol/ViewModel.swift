//
//  ViewModel.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 3/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

typealias ViewModelCallback = ()->()

protocol ViewModel {
    func setCallback(_ callback: @escaping ViewModelCallback)
}
