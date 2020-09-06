//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Aaron Cleveland on 9/5/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Reference to the managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // Data for the table
    var items: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Get items from Core Data
        fetchPeople()
    }
    
    func relationshipDemo() {
        // Create a family
        let family = Family(context: context)
        family.name = "Simpsons"
        
        // Create a person
        let person = Person(context: context)
        person.name = "Maggie"
        person.family = family
        
        // Add person to family
        family.addToPeople(person)
        
        // Save context
        do {
         try self.context.save()
        } catch {
            
        }
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        print("ADD BUTTON TAPPED")
        // Create alert
        let alert = UIAlertController(title: "Add Person", message: "What is their name?", preferredStyle: .alert)
        alert.addTextField()
        
        // Configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // Get the textfield for the alert
            let textField = alert.textFields![0]
            
            //TODO: Create a person object
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            newPerson.age = 20
            newPerson.gender = "Male"
            
            //TODO: Save the data
            // this method does throw so we can throw it in a do-catch block and try to catch the error.
            
            do {
                try self.context.save()
                self.tableView.reloadData()
            } catch {
                print("Error saving data")
            }
            
            //TODO: Re-Fetch the data
            self.fetchPeople()
        }
        
        // Add Button to alert
        alert.addAction(submitButton)
        
        // show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func fetchPeople() {
        // Fetch the data from CoreData to display in the tableView
        do {
            // Trying to fetch
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            self.items = try context.fetch(request)
            
            // filtering
//            let pred = NSPredicate(format: "name CONTAINS %@", "Ted")
//            request.predicate = pred
            
            // sorting
//            let sort = NSSortDescriptor(key: "name", ascending: true)
//            request.sortDescriptors = [sort]
            
            
            // Because tableView is being reloaded and it's UI, we dont want it to perform on the backend for performance issues. So we attach it to the main thread.
            DispatchQueue.main.async {
                // than update the tableview.
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        // TODO: Get person from array and set the label
        let person = self.items![indexPath.row]
        cell.textLabel?.text = person.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // selected person
        let person = self.items![indexPath.row]
        
        // Create alert
        let alert = UIAlertController(title: "Edit Person", message: "Edit Name:", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields![0]
        textField.text = person.name
        
        //configure button handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            // get the textfield for the alert
            let textField = alert.textFields![0]
            
            // todo: edit name property of person object
            person.name = textField.text
            
            // todo: save the data
            do {
                try self.context.save()
            } catch {
                
            }
            
            // re-fetch the data
            self.fetchPeople()
        }
        
        // add button
        alert.addAction(saveButton)
        
        // show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            // todo: Which person to remove
            let personToRemove = self.items![indexPath.row]
            
            
            // todo: remove the person
            self.context.delete(personToRemove)
            
        
            // todo: save the data
            do {
                try self.context.save()
            } catch {
                
            }
        
            // re-fetch the data
            self.fetchPeople()
        }
        
        // return swipe actions
        return UISwipeActionsConfiguration(actions: [action])
    }
}

