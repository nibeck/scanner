//
//  ItemTableViewController.swift
//  Scanner
//
//  Created by Mike Nibeck on 6/22/16.
//  Copyright © 2016 Mike Nibeck. All rights reserved.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {

    var items = [NSManagedObject] ()
    
    // Pull data from core data
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load items from Core Data
        self.fetchItems()
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Create new cell with custom cell class
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemTableViewCell
        
        let item = items[indexPath.row]
        
        cell.nameTextField.text = item.valueForKey("name") as? String
        cell.barcodeTextField.text = item.valueForKey("barCode") as? String
        
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            // Find the LogItem object the user is trying to delete
            let itemToDelete = items[indexPath.row]
            
            // Delete it from the managedObjectContext
            managedContext.deleteObject(itemToDelete)
            
            // Refresh the table view to indicate that it's deleted
            self.fetchItems()
            
            // Tell the table view to animate out that row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        } else if editingStyle == .Insert {
            // Create a new dinstance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "ShowDetail" { // tapped on cell
            let itemDetailViewController = segue.destinationViewController as! ItemViewController
            
            // Get the cell that generated this segue.
            if let selectedItemCell = sender as? ItemTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedItemCell)!
                
                let selectedItem = items[indexPath.row]
                let tmpItem = Item()
                tmpItem.name = (selectedItem.valueForKey("name") as? String)!
                tmpItem.barcode = (selectedItem.valueForKey("barCode") as? String)!
              
                itemDetailViewController.item = tmpItem
            }
        }
        // Add new Item
        else if segue.identifier == "AddItem" {
            print("Adding new item.")
        }
    }
 
    // MARK: Data stuff
    
    //fetch Items
    func fetchItems() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Item")
        
        // try and load
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
                items = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    func persistItem(newItem: Item) {
        // Get managedObject context
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // Create an Item entity
        let entity =  NSEntityDescription.entityForName("Item",
                                                        inManagedObjectContext:managedContext)
        
        
        
        let item1 = NSManagedObject(entity: entity!,
                                    insertIntoManagedObjectContext: managedContext)
        // Set attribs
        item1.setValue(newItem.name, forKey: "name")
        item1.setValue(newItem.barcode, forKey: "barCode")
        item1.setValue(nil, forKey: "image")
        do {
            try managedContext.save()
            // Try and save
            items.append(item1)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // Delegate call-back from ItemViewController - called when Save is hit
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ItemViewController, item = sourceViewController.item {
            
            // IF editing existing vs. adding new
            if let selectedIndexPath = tableView.indexPathForSelectedRow { // editing
            
                // Create NSmanaged object to replace the ecisting one in the array
                // TODO: This can probably be repalced with something more elegant
                let appDelegate =
                    UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                
                // Create an Item entity
                let entity =  NSEntityDescription.entityForName("Item",
                                                                inManagedObjectContext:managedContext)
                
                
                
                let itemEntity = NSManagedObject(entity: entity!,
                                            insertIntoManagedObjectContext: managedContext)
                // Set attribs
                itemEntity.setValue(item.name, forKey: "name")
                itemEntity.setValue(item.barcode, forKey: "barCode")
                itemEntity.setValue(nil, forKey: "image")
                
                items[selectedIndexPath.row] = itemEntity;
                
                // need to replace managed object in array.
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                
            }
            else {
                // If this was called by the ItemViewController, then grab the passed item object from that controller and assign to local item object
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: items.count, inSection: 0)
                
                persistItem(item)
                
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                }
        }
    }
    
    // MARK: Set-up
    func loadSampleItems() {

        // Get managedObject context
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // Create an Item entity
        let entity =  NSEntityDescription.entityForName("Item",
                                                        inManagedObjectContext:managedContext)
        
        
        
        let item1 = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        // Set attribs
        //let photo1 = UIImage(named: "defaultPhoto")!
        item1.setValue("iPhone 6", forKey: "name")
        item1.setValue("00437662558", forKey: "barCode")
        item1.setValue(nil, forKey: "image")
        
        let item2 = NSManagedObject(entity: entity!,
                                    insertIntoManagedObjectContext: managedContext)
        // Set attribs
        item2.setValue("Macbook Pro 13\"", forKey: "name")
        item2.setValue("HGF45JK9987558", forKey: "barCode")
        item2.setValue(nil, forKey: "image")

        do {
            try managedContext.save()
            // Try and save
            items.append(item1)
            items.append(item2)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }

}
