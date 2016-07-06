//
//  PeoplePopoverController.swift
//  Scanner
//
//  Created by Mike Nibeck on 6/29/16.
//  Copyright © 2016 Mike Nibeck. All rights reserved.
//

import UIKit
import CoreData

class PeoplePopoverController: UITableViewController {
        var people = [NSManagedObject] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        //navigationItem.leftBarButtonItem = editButtonItem()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.fetchPeople()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        
        let person = people[indexPath.row]
        
        let firstName:String? = person.valueForKey("firstName") as? String
        let lastName:String?  = person.valueForKey("lastName") as? String
        let displayName:String? = lastName! + ", " + firstName!
        
        cell.textLabel?.text = displayName
        
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
}
