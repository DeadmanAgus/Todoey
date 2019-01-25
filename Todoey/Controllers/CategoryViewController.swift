//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Agus Hernandez on 1/24/19.
//  Copyright © 2019 Agus Hernandez. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    /* Each Item is created by the CoreData framework, so any change to them is later persisted when the context is persisted */
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Print (SQLite) database location: */
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadCategories()
    }

    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
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
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    // MARK: - TableView Data Manipulation Methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Created to store a refenrence to the textField inside the alert since that's only visible inside the closure.
        var textField: UITextField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let category = Category(context: self.context)
            category.name = textField.text!
            
            self.categories.append(category)
            
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategories(){
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    /* parameter with default value */
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error retrieving data from context, \(error)")
        }
        
        self.tableView.reloadData()
    }
}
