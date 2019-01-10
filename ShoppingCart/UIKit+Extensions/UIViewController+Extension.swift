//
//  UIViewController+Extension.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

extension UIButton {
    func setImageContentMode(_ mode: ContentMode! = .scaleAspectFit) {
        self.imageView?.contentMode = mode
    }
}
