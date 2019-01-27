//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Agus Hernandez on 1/24/19.
//  Copyright © 2019 Agus Hernandez. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    /* Each Item is created by the CoreData framework, so any change to them is later persisted when the context is persisted */
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Print (SQLite) database location: */
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadCategories()
    }

    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /* if categories is null then return 1; otherwise return the count */
        return categories?.count ?? 1
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet."
        
        return cell
     }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        /* indexPathForSelectedRow could be nil so we used a if let statement. */
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    // MARK: - TableView Data Manipulation Methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Created to store a refenrence to the textField inside the alert since that's only visible inside the closure.
        var textField: UITextField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let category = Category()
            category.name = textField.text!
            
            self.save(category: category)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    /* parameter with default value */
    func loadCategories(){
        /*Load all the categories*/
        categories = realm.objects(Category.self)

        self.tableView.reloadData()
    }
}
