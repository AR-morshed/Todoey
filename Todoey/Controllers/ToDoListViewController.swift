//
//  ViewController.swift
//  Todoey
//
//  Created by Arman morshed on 13/3/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import UIKit
import ChameleonFramework
import RealmSwift

class ToDoListViewController: SwipeTableViewController{
    
    var  todoItem: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory: Category? {
        didSet{
            loadIteams()
        }
    }

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
         tableView.separatorStyle = .none
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color{
            
            title = selectedCategory!.name
            
            
            guard let navBar = navigationController?.navigationBar else{
                fatalError("Navigation controller does not exist")
            }
            
            
            navBar.barTintColor = UIColor(hexString: colorHex)
            navBar.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: UIColor(hexString: colorHex), isFlat: true)
            
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(contrastingBlackOrWhiteColorOn: UIColor(hexString: colorHex), isFlat: true)]
            
            
            searchBar.barTintColor = UIColor(hexString: colorHex)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "1D9BF6") else{
            fatalError()
        }
        
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor  = UIColor.flatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.flatWhite()]
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItem?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat( indexPath.row) / CGFloat(todoItem!.count)){
                        cell.backgroundColor = color
                
                cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn:color, isFlat: true)


            }
            
            
            
            
            //Ternary Operator
            //value = condition ? valueifTrue : valueifFalse
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items Added"
        }
        
        
        
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItem?[indexPath.row]{
           
            do{
            try realm.write {
                item.done = !item.done
            }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        

    }
    

    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user clicks the Add Item Button on our UIAlert
            
            if let currentCategory = self.selectedCategory{
               
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                }catch{
                    print("Error saving new Items \(error)")
                }
                
            }
        
            
            self.tableView.reloadData()
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    

    func loadIteams( ){

       todoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }


    //MARK - Delete items using Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.todoItem?[indexPath.row]{
            
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                
                print("Error deleting category, \(error)")
            }
            
        }
        
    }
    
}

// MARK - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItem = todoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadIteams()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
    
}

