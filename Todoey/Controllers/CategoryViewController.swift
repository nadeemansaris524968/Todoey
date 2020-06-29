//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nadeem Ansari on 6/29/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        
    }
}
