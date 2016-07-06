//
//  personTableViewController.swift
//  Scanner
//
//  Created by Mike Nibeck on 6/15/16.
//  Copyright © 2016 Mike Nibeck. All rights reserved.
//

import UIKit
import CoreData

class personTableViewController: UITableViewController {

    var people = [NSManagedObject] ()
   
    
    // Pull data from core data
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load items from Core Data
        self.fetchPeople()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return people.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Create new cell with custom cell class 
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath) as! PersonTableViewCell
        
        let person = people[indexPath.row]
        
        let firstName:String? = person.valueForKey("firstName") as? String
        let lastName:String?  = person.valueForKey("lastName") as? String
        let emailAddress:String? = person.valueForKey("email") as? String
        
        let displayName:String? = lastName! + ", " + firstName!
        
        cell.fullNameField.text = displayName
        cell.emailField.text? = emailAddress!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            // Find the LogItem object the user is trying to delete
            let personToDelete = people[indexPath.row]
            
            // Delete it from the managedObjectContext
            managedContext.deleteObject(personToDelete)
            
            // Refresh the table view to indicate that it's deleted
            self.fetchPeople()
            
            // Tell the table view to animate out that row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert { }
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "ShowPerson" { // tapped on cell
            let personDetailViewController = segue.destinationViewController as! PersonViewController
            
            // Get the cell that generated this segue.
            if let selectedItemCell = sender as? ItemTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedItemCell)!
                
                let selectedItem = people[indexPath.row]
                let tmpPerson = Person()
                tmpPerson.firstName = (selectedItem.valueForKey("firstName") as? String)!
                tmpPerson.lastName = (selectedItem.valueForKey("lastName") as? String)!
                tmpPerson.emailAddress = (selectedItem.valueForKey("email") as? String)!
                
                personDetailViewController.person = tmpPerson
            }
        }
            // Add new Item
        else if segue.identifier == "AddPerson" {
            print("Adding new person.")
        }
    }
    
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        print (sender.sourceViewController)
        
        if let sourceViewController = sender.sourceViewController as? PersonViewController, person = sourceViewController.person {
            //IF editing existing vs. adding new
            if let selectedIndexPath = tableView.indexPathForSelectedRow { // editing
                
                // Create NSmanaged object to replace the ecisting one in the array
                let appDelegate =
                    UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                
                // Create an Person entity
                let entity =  NSEntityDescription.entityForName("Person",
                                                                inManagedObjectContext:managedContext)
                let personEntity = NSManagedObject(entity: entity!,
                                                 insertIntoManagedObjectContext: managedContext)
                // Set attribs
                personEntity.setValue(person.firstName, forKey: "firstName")
                personEntity.setValue(person.lastName, forKey: "lastName")
                personEntity.setValue(person.emailAddress, forKey: "email")
                personEntity.setValue(nil, forKey: "photo")
                
                people[selectedIndexPath.row] = personEntity
                
                // need to replace managed object in array.
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                
            }
            else {
                // If this was called by the ItemViewController, then grab the passed item object from that controller and assign to local item object
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: people.count, inSection: 0)
                
                persistItem(person)
                
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }
    
    // MARK: Data stuff
    //fetch Items
    func fetchPeople() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        // try and load
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    // save object
    func persistItem(newPerson: Person) {
        // Get managedObject context
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // Create an Item entity
        let entity =  NSEntityDescription.entityForName("Person",
                                                        inManagedObjectContext:managedContext)
        
        let personEntity = NSManagedObject(entity: entity!,
                                    insertIntoManagedObjectContext: managedContext)
        // Set attribs
        
        personEntity.setValue(newPerson.firstName, forKey: "firstName")
        personEntity.setValue(newPerson.lastName, forKey: "lastName")
        personEntity.setValue(newPerson.emailAddress, forKey: "email")
        personEntity.setValue(nil, forKey: "photo")
        do {
            try managedContext.save()
            // Try and save
            people.append(personEntity)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

}
