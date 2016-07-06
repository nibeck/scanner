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

    //var nameList: [String] = ["Mike", "Steve", "Amy"]
    var people = [NSManagedObject] ()
    var email = String()
    
    // Pull data from core data
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // grab context
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // entity to fetch
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("PeopleCell")! as UITableViewCell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath) as! PersonTableViewCell

        //cell.backgroundColor = UIColor.redColor()
        
        let person = people[indexPath.row]
        let firstName:String? = person.valueForKey("firstName") as? String
        let lastName:String?  = person.valueForKey("lastName") as? String
        let emailAddress:String? = person.valueForKey("email") as? String
        
        print (emailAddress)
        
        let displayName:String? = lastName! + ", " + firstName! + " (" + emailAddress! + ")"
        
        //let displayName: String = "test"
        
        print (displayName)
        
        cell.fullNameField.text = displayName
        //cell.emailAddressField.text? = emailAddress!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // remove the deleted item from the model
            // grab context
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            managedContext.deleteObject(people[indexPath.row] as NSManagedObject)
            people.removeAtIndex(indexPath.row)
            do {
                try managedContext.save()
            } catch _ {
            }
            
            //tableView.reloadData()
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    @IBAction func addPeopleAlert(sender: AnyObject) {        //Create the AlertController
        let alert: UIAlertController = UIAlertController(title: "Add User", message: nil, preferredStyle: .Alert)
        
        //Add a text field
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "First Name" }
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Last Name" }
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = .EmailAddress
        }
        
        //Create and an Save action
        let saveAction: UIAlertAction = UIAlertAction(title: "Save", style: .Default) { action -> Void in
            //Do some other stuff
            print ("Saving....", alert.textFields![0].text! )
            self.saveName(alert.textFields![0].text!,
                          lastName: alert.textFields![1].text!,
                           email: alert.textFields![2].text!)

            self.tableView.reloadData()

        }
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        }
        
        // Add the actions
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    // MARK: CoreData
    func saveName(firstName: String, lastName: String, email: String) {
        // Get managedObject context
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // Create a person entity
        let entity =  NSEntityDescription.entityForName("Person",
                                                        inManagedObjectContext:managedContext)
        
        let person = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
 
        print ("FirstName:", firstName)
        
        // Set attribs
        person.setValue(firstName, forKey: "firstName")
        person.setValue(lastName, forKey: "lastName")
        person.setValue(email, forKey: "email")

        do {
            try managedContext.save()
            // Try and save
            people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
