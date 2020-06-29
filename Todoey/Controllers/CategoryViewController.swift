//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nadeem Ansari on 6/29/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryArray: [Category] = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        super.viewDidLoad()
        loadCategories()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            guard let destinationVC = segue.destination as? TodoListViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Nav Add Button Item method
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        var tField = UITextField()
        let alertVC = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if tField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                guard let categoryTitle = tField.text else { return }
                let category = Category(context: self.context)
                category.name = categoryTitle
                self.categoryArray.append(category)
                self.saveCategories()
                self.tableView.reloadData()
            }
        }
        alertVC.addTextField { (textField) in
            textField.placeholder = "Eg: School or Office"
            tField = textField
        }
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation methods
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
}

extension CategoryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadCategories(with: request)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadCategories()
            tableView.reloadData()
        }
    }
}
