//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray: [Item] = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    var dataFilePath: URL? = nil
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Table View Data Source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = (item.done) ? .checkmark : .none
        return cell
    }
    
    //MARK: - Table View Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        item.done = !item.done
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        selectedCell.accessoryType = (item.done) ? .checkmark : .none
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
                let item = Item(context: self.context)
                item.title = todoItem
                item.done = false
                item.parentCategory = self.selectedCategory
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
    
    //MARK: - Data Manipulation methods
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), and extraPredicate: NSPredicate? = nil) {
        guard let parentCategoryName = selectedCategory?.name else { return }
        let basePredicate: NSPredicate = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", parentCategoryName)
        do {
            request.predicate = (extraPredicate != nil) ? NSCompoundPredicate(andPredicateWithSubpredicates: [basePredicate, extraPredicate!]) : basePredicate
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
}

//MARK: - Search Bar Delegate methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, and: titlePredicate)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadItems()
            tableView.reloadData()
        }
    }
}
