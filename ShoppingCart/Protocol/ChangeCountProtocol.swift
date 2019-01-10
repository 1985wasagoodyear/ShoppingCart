//
//  ChangeCountProtocol.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

protocol ChangeCountProtocol: class {
    func incrementCount(_ index: Int)
    func decrementCount(_ index: Int)
}
