//
//  UIKit+Extension.swift
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

extension UIViewController {
    func showAlert(text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
