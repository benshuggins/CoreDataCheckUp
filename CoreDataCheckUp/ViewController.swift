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
  
    
    
    var fetchedResultsController: NSFetchedResultsController<Person>! //1
    
    var items: [Person]?   // This is the core data sot
  
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//
//        tableView.reloadData()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
        tableView.frame = view.bounds
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapBarButton))
        
        navigationItem.rightBarButtonItem = add
     
        
      //  fetchPeople()  // this is the old NSFetch()
        fetchPeopleResultsController() // this is with NSFetchResultsController
    }
    
    // This doesn't use NSFETCHRESULTSCONTROLLER
    
//    func fetchPeople() {
//        do {
//            // This only fetches the Name Ted
//            let request = Person.fetchRequest() as NSFetchRequest<Person>
////            let predicate = NSPredicate(format: "name CONTAINS 'Ted'")
////            request.predicate = predicate
//            self.items = try context.fetch(request)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        } catch {
//            // handle error
//        }
//    }
    
    func fetchPeopleResultsController() {
        if fetchedResultsController == nil {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            let sort = NSSortDescriptor(key: "name", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            
        }
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Error: \(error)")
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
            self.fetchPeopleResultsController()
           // self.fetchPeople()
        }
        
        alert.addAction(submitButton)
       
      
          //  self?.createItem(name: text)
        present(alert, animated: true)
           // self?.tableView.reloadData()
    
        }
       
       // self.lists.append(text)
        

//
//
//    func createItem(name: String) {
//        let createdAt = Date()
//    let newName = Person(name: name)
//        items?.append(newName)
//        //models.append(newName)
//        tableView.reloadData()
//    }
//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     //   return items?.count ?? 0    // this is the NSfetched() way
        
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
        //let person = self.items![indexPath.row] // old way
        let person = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = person.name
        return cell
    }
  
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let person = fetchedResultsController.object(at: indexPath)
            context.delete(person)
            
            do {
                try context.save()
                
            } catch {
                print("error")
            }
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** ControllerWillChangeContent")
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
      didChange anObject: Any,
      at indexPath: IndexPath?,
      for type: NSFetchedResultsChangeType,
      newIndexPath: IndexPath?
    ) {
      switch type {
      case .insert:
        print("*** NSFetchedResultsChangeInsert (object)")
        tableView.insertRows(at: [newIndexPath!], with: .fade)

      case .delete:
        print("*** NSFetchedResultsChangeDelete (object)")
        tableView.deleteRows(at: [indexPath!], with: .fade)

      case .update:
        print("*** NSFetchedResultsChangeUpdate (object)")
     //   if let cell = tableView.cellForRow(
//          at: indexPath!) as? LocationCell {
//          let location = controller.object(
//            at: indexPath!) as! Location
//          cell.configure(for: location)
//        }

      case .move:
        print("*** NSFetchedResultsChangeMove (object)")
        tableView.deleteRows(at: [indexPath!], with: .fade)
        tableView.insertRows(at: [newIndexPath!], with: .fade)

      @unknown default:
        print("*** NSFetchedResults unknown type")
      }
    }

    func controller(
      _ controller: NSFetchedResultsController<NSFetchRequestResult>,
      didChange sectionInfo: NSFetchedResultsSectionInfo,
      atSectionIndex sectionIndex: Int,
      for type: NSFetchedResultsChangeType
    ) {
      switch type {
      case .insert:
        print("*** NSFetchedResultsChangeInsert (section)")
        tableView.insertSections(
          IndexSet(integer: sectionIndex), with: .fade)
      case .delete:
        print("*** NSFetchedResultsChangeDelete (section)")
        tableView.deleteSections(
          IndexSet(integer: sectionIndex), with: .fade)
      case .update:
        print("*** NSFetchedResultsChangeUpdate (section)")
      case .move:
        print("*** NSFetchedResultsChangeMove (section)")
      @unknown default:
        print("*** NSFetchedResults unknown type")
      }
    }

    func controllerDidChangeContent(
      _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
      print("*** controllerDidChangeContent")
      tableView.endUpdates()
    }
    
}
        



