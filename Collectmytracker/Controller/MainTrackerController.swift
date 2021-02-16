//
//  MainTrackerController.swift
//  Collectmytracker
//
//  Created by kittawat phuangsombat on 2021/1/16.
//

import UIKit
import CoreData

class MainTrackerController: UITableViewController {
  
  var tracker = [Tracker]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadTrackers()
    tableView.separatorStyle = .none
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.setToolbarHidden(true, animated: true)
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
  //deleting rows
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      alertConfirmationToDelete(at: indexPath)
      
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
  }
  
  func deleteRow(_ indexPath: IndexPath, _ tableView: UITableView) {
    context.delete(tracker[indexPath.row])
    tracker.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
  
  
  
  
  //MARK: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToTrackerData", sender: self)
    tableView.deselectRow(at: indexPath as IndexPath, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! ItemDataViewController
    
    if let indexPath = tableView.indexPathForSelectedRow{
      destinationVC.selectedTracker = tracker[indexPath.row]
    }else{
      destinationVC.selectedTracker = tracker.last
    }
    
    let backItem = UIBarButtonItem()
    backItem.title = ""
    navigationItem.backBarButtonItem = backItem
    
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
      
      self.performSegue(withIdentifier: "goToTrackerData", sender: self)
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
    
    alert.addAction(action)
    alert.addAction(cancel)
    
    alert.addTextField { (field) in
      textField = field
      textField.placeholder = "Add a new tracker"
    }
    
    present(alert, animated: true, completion: nil)
  }
  
  
}
