//
//  ViewController.swift
//  Todoey
//
//  Created by Agus Hernandez on 1/23/19.
//  Copyright © 2019 Agus Hernandez. All rights reserved.
//

import UIKit
import CoreData

/* As this class subclasses the UITableViewController we don't need an outlet pointing to the table view */
class TodoListViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /* Each Item is created by the CoreData framework, so any change to them is later persisted when the context is persisted */
    var itemArray = [Item]()
    var selectedCategory: Category?{
        /* Triggered as soon as this variable is set to a value */
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Print (SQLite) database location: */
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }

    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        /* To delete items */
        /*
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        saveItems()
        */
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Created to store a refenrence to the textField inside the alert since that's only visible inside the closure.
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    /* parameter with default value */
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory,name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            let coumpundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
            request.predicate = coumpundPredicate
        }else{
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error retrieving data from context, \(error)")
        }
        
        self.tableView.reloadData()
    }

}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        /* https://academy.realm.io/posts/nspredicate-cheatsheet/ */
        /* cd will make it caseless and accents less, see https://nshipster.com/nspredicate/ */
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            /* Run this method on the main queue */
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
