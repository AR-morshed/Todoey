//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Arman morshed on 14/3/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import UIKit

import RealmSwift
import ChameleonFramework


class CategoryViewControllerTableViewController: SwipeTableViewController {

    
    let realm = try! Realm()
    
    var  categories: Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        tableView.separatorStyle = .none
        
        
    }

    
    //MARK - TableView DataSource Mathods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
         let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories Addes yet"
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "109BF6")
        
        
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
    
    //MARK -Delete dataFrom Swipe
    
    override func updateModel(at indexPath: IndexPath){
                    if let categoryForDeletion = self.categories?[indexPath.row]{
        
                        do{
                            try self.realm.write {
                                self.realm.delete(categoryForDeletion)
                            }
                        }catch{
        
                            print("Error deleting category, \(error)")
                        }
        
                    }
    }
    
    //MARK - Add new Categories
 
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //What will happen once the user clicks the Add Item Button on our UIAlert
            
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
            if let color = UIColor.randomFlat()?.hexValue(){
                newCategory.color = color
            }
            
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
    



    

    
    
    
    

