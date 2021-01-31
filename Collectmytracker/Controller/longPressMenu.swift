//
//  longPressMenu.swift
//  Collectmytracker
//
//  Created by kittawat phuangsombat on 2021/1/30.
//

import UIKit

//MARK: - for item menu


extension ItemDataViewController {
        
    //long press to open menu
     func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            return self.menuForItems(at: indexPath)
        }
    }
   
    func menuForItems(at indexPath: IndexPath) -> UIMenu {

        // Create a UIAction for sharing
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
            // Show system share sheet
        }

        // Create an action for renaming
        let rename = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { action in
            // Perform renaming
        }

        // Here we specify the "destructive" attribute to show that it’s destructive in nature
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            self.deleteItem(at: indexPath)
            
        }

        // Create and return a UIMenu with all of the actions as children
        return UIMenu(title: "", children: [share, rename, delete])
    }
}

//MARK: - for tracer menu

extension MainTrackerController{
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions -> UIMenu? in
            return self.menuForTrackers(at: indexPath)
        }
    }
    
    func menuForTrackers(at indexPath: IndexPath) -> UIMenu {

        // Create an action for renaming
        let rename = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { action in
            // Perform renaming
            self.renaming(at: indexPath)
        }

        // Here we specify the "destructive" attribute to show that it’s destructive in nature
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            self.alertConfirmationToDelete(at: indexPath)
      
        }

        // Create and return a UIMenu with all of the actions as children
        return UIMenu(title: "", children: [rename, delete])
    }
    func alertConfirmationToDelete(at indexPath: IndexPath) {
        let confirmationToDelete = UIAlertController(title: "Confirmation to delete?", message: "this action is not reversible", preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "Confirm", style: .destructive) { (action) in
            self.deleteRow(indexPath, self.tableView)
            self.saveTrackers()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        confirmationToDelete.addAction(action)
        confirmationToDelete.addAction(cancel)
        
        present(confirmationToDelete, animated: true, completion: nil)
    }
    
    func renaming(at indexPath : IndexPath) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Edit Tracker Name", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Confirm", style: .default) { (action) in
            let editingTracker = self.tracker[indexPath.row]
            editingTracker.name = textField.text!
            
            self.saveTrackers()
            
//            let newTracker = Tracker(context: self.context)
//            newTracker.name = textField.text!
//
//            self.tracker.append(newTracker)
//            self.saveTrackers()
//
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Edit tracker Name here"
        }
        
        present(alert, animated: true, completion: nil)
    }
}

