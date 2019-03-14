//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Arman morshed on 14/3/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


class CategoryViewControllerTableViewController: UITableViewController {

    
    let realm = try! Realm()
    
    var  categories: Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    
    //MARK - TableView DataSource Mathods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories Addes yet"
        
        return cell
    }
    
    
    
    
    
    //MARK - Data MAnupulation Mathods
    func save(category: Category ){
        
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            
            print("Error saving category \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        
        
         categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK - Add new Categories
 
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //What will happen once the user clicks the Add Item Button on our UIAlert
            
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK -  TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToitems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as!  ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row] 
        }
    }
    
    
    }
    
    
    
    

    
    
    
    

