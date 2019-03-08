//
//  UIStoryboard+Main.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 3/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

extension UIStoryboard {
    private static let main = UIStoryboard(name: "Main", bundle: nil)
    
    static func getFromMain(_ name: String) -> UIViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: name)
    }
}

