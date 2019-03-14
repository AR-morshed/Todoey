//
//  ViewController.swift
//  Todoey
//
//  Created by Arman morshed on 13/3/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    var  itemArray = [Item]()
    var selectedCategory: Category? {
        didSet{
            loadIteams()
        }
    }

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary Operator
        //value = condition ? valueifTrue : valueifFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        //simple if else type
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        

    }
    

    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user clicks the Add Item Button on our UIAlert
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCatagory = self.selectedCategory
            self.itemArray.append(newItem)
            
           self.saveItems()
            
            
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems(){
       
        
        do{
           try context.save()
        }catch{
            
            print("Error saving context \(error)")
        }
        
         self.tableView.reloadData()
    }

    func loadIteams(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ){
        
       let categoryPredicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
      
        
        do{
            itemArray =  try context.fetch(request)
        }catch{
            print("Error factching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    
    
}

// MARK - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadIteams(with: request, predicate: predicate)
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

