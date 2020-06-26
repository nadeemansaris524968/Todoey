//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray: [Item] = [Item]()
    var dataFilePath: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            dataFilePath = filePath.appendingPathComponent("Items.plist")
            print(dataFilePath!)
            loadItems()
        }
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
        saveItems()
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
                self.saveItems()
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
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            guard let filePath = self.dataFilePath else { return }
            try data.write(to: filePath)
        } catch {
            print(error)
        }
    }
    
    func loadItems() {
        guard let dataFilePath = dataFilePath else { return }
        do {
            guard let data = try? Data(contentsOf: dataFilePath) else { return }
            let decoder = PropertyListDecoder()
            itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error loading items: \(error)")
        }
    }
}
