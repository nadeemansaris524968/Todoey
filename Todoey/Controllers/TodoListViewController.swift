//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray: [Item] = [
        Item(title: "Find Mike"),
        Item(title: "Buy Eggos"),
        Item(title: "Destroy Demogorgon")
    ]
    
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Table View Data Source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.getTitle()
        cell.accessoryType = (item.isDone()) ? .checkmark : .none
        return cell
    }
    
    //MARK: - Table View Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        item.toggle()
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        selectedCell.accessoryType = (item.isDone()) ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Nav Add Button Item method
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var tField = UITextField()
        let alertVC = UIAlertController(title: "Add new Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if tField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                guard let todoItem = tField.text else { return }
                let item = Item(title: todoItem)
                self.itemArray.append(item)
                self.tableView.reloadData()
            }
        }
        alertVC.addTextField { (textField) in
            textField.placeholder = "Eg: Complete meeting notes"
            tField = textField
        }
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}
