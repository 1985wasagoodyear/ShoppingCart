//
//  ShoppingCartViewController.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

final class ShoppingCartViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var viewModel = ShoppingCartViewModel()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()

    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: ProductTableViewCell.name,
                        bundle: nil)
        self.tableView.register(nib,
                                forCellReuseIdentifier: ProductTableViewCell.name)
    }


}

extension ShoppingCartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.name, for: indexPath) as! ProductTableViewCell
        
        // setup
        
        return cell
    }
}
