//
//  MainTrackerController.swift
//  Collectmytracker
//
//  Created by kittawat phuangsombat on 2021/1/16.
//

import Foundation
import UIKit
import CoreData

class MainTrackerController: UITableViewController {
    //    var categories = [Category]()
    //
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tracker = [Tracker]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Data Manipulation Methods
    
    func saveTrackers() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    //MARK: - add new tracker
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Tracker", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newTracker = Tracker(context: self.context)
            newTracker.name = textField.text!
            
            self.tracker.append(newTracker)
            self.saveTrackers()
            
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new tracker"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
