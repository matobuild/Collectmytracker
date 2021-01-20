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
    
    var tracker = [Tracker]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTrackers()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracker.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath)
        
        cell.textLabel?.text = tracker[indexPath.row].name
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTrackerData", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TrackerDataViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedTracker = tracker[indexPath.row]
        }
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveTrackers() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    func loadTrackers() {
        
        let request : NSFetchRequest<Tracker> = Tracker.fetchRequest()
        
        do{
            tracker = try context.fetch(request)
        } catch {
            print("Error loading trackers \(error)")
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
