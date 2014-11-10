    //
//  ViewController.swift
//  List
//
//  Created by Nyrene on 11/3/14.
//  Copyright (c) 2014 ___Nyx___. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var people = [NSManagedObject]()

    @IBAction func addName(sender: AnyObject) {
        var alert = UIAlertController(title: "New name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) {
            (action: UIAlertAction!) -> Void in
            
            
            let textField = alert.textFields![0] as UITextField
            self.saveName(textField.text)
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        //3
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            people = results
        } else {
            println("Could not fetch error \(error), \(error!.userInfo)")
        }
    }
    
    func saveName(name: String) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext =  appDelegate.managedObjectContext!
        //2
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        //3
        person.setValue(name, forKey: "Name")
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            
        }

        let currentName: String = person.valueForKey("Name") as String
        
        people.append(person)

        println("appended \(currentName) to people")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
//        //According to tutorial, this should be cell.textLabel!.text, but that causes an error
//        cell.textLabel.text = people[indexPath.row]
        
        
        let person = people[indexPath.row]
//        // - this block of code was not in the tutorial
//        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        let managedContext = appDelegate.managedObjectContext!
//        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
//        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
//    
//        
//        //This was in tutorial but causes an error; creating a variable and
//        //assigning it the value and giving that to cell.textLabel causes a different error
//        //Now it no longer causes an error for some reason
        cell.textLabel.text = person.valueForKey("Name") as String?
//
//        
//        var value = person.valueForKey("Name")
//        println("value: \(value), ")
        
        return cell
    }


}

