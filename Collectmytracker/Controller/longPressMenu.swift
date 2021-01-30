//
//  longPressMenu.swift
//  Collectmytracker
//
//  Created by kittawat phuangsombat on 2021/1/30.
//

import UIKit

extension TrackerDataViewController {
        
    //long press to open menu
     func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            return self.optionsSmallMenu(at: indexPath)
        }
    }
   
    func optionsSmallMenu(at indexPath: IndexPath) -> UIMenu {

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
