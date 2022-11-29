//
//  ViewController.swift
//  CoreDataCheckUp
//
//  Created by Ben Huggins on 11/22/22.
//

//
//  ViewController.swift
//  CoreDataRefresher
//
//  Created by Ben Huggins on 11/22/22.
//

import UIKit
import CoreData 


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    var models = [ToDoListItem]()
    
    var items: [Person]?   // This is the core data sot
  
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
        tableView.frame = view.bounds
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapBarButton))
        
        navigationItem.rightBarButtonItem = add
        
        fetchPeople()
    }
    
    func fetchPeople() {
        // get people from Core Data
        do {
            
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            let predicate = NSPredicate(format: "name CONTAINS 'Ted'")
            
            request.predicate = predicate
            
            self.items = try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
           
        } catch {
            // handle error
        }
        
    }
    
    @objc func didTapBarButton() {
       
        let alert = UIAlertController(title: "Add Person", message: "What is your name?", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let textField = alert.textFields?[0]
            
            let newPerson = Person(context: self.context)
            newPerson.name = textField?.text
            newPerson.age = Date()
            
            do {
                try self.context.save()
            } catch {
                 // catch the error
            }
            
            self.fetchPeople()
        }
        
        alert.addAction(submitButton)
       
      
           // self?.createItem(name: text)
        present(alert, animated: true)
           // self?.tableView.reloadData()
    
        }
       
       // self.lists.append(text)
        

//
//
//    func createItem(name: String) {
//        let createdAt = Date()
//       // let newName = Person(name: name)
//        items?.append(newName)
//        //models.append(newName)
//        tableView.reloadData()
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = self.items![indexPath.row]
        cell.textLabel?.text = person.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let person = self.items![indexPath.row]
     
        let alert = UIAlertController(title: "Edit Person", message: "Edit name: ", preferredStyle: .alert)
        
        alert.addTextField()
        
        let textField = alert.textFields![0]
        textField.text = person.name
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            let textField = alert.textFields![0]
            
            person.name = textField.text
            
            do {
                try self.context.save()
            } catch {
                
            }
            
            self.fetchPeople()
        }
        
        alert.addAction(saveButton)
        
        self.present(alert, animated: true)
     
    
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionLike = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            
            let personToRemove = self.items![indexPath.row]
            
            self.context.delete(personToRemove)
            
            do {
               try self.context.save()
            } catch {
                
            }
            
            self.fetchPeople()
            
            completionHandler(true)
            
            
        }
        return UISwipeActionsConfiguration(actions: [actionLike])
    }
    
    }

        
        



