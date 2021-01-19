//
//  ViewController.swift
//  Collectmytracker
//
//  Created by kittawat phuangsombat on 2021/1/16.
//


import UIKit
import CoreData

class TrackerDataViewController: UIViewController {
    
    var itemArray = [Item]()
    
    var selectedTracker : Tracker?{
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
   
    var items = [0]
    
    
    //MARK: - Model Manipulation Methods
    func saveItems() {
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        //    NEED TO RELOAD GRID
//        self.tableView.reloadData()
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let trackerPredicate = NSPredicate(format: "parentTracker.name MATCHES %@", selectedTracker!.name!)
        
        if let additionalPredeicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [trackerPredicate,additionalPredeicate])
        }else{
            request.predicate = trackerPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        //    NEED TO RELOAD GRID
        //    tableView.reloadData()
        
    }
}


//MARK: - creating the grid

extension TrackerDataViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
//        cell.myLabel.text = String(self.items[indexPath.row])// The row value is the same as the index of the desired text within the array.
        if indexPath.item == items.count-1{
            cell.myImage.image = #imageLiteral(resourceName: "offline")
        }else{
            cell.myImage.image = #imageLiteral(resourceName: "online")
        }
        print("idexpath. item is \(indexPath.item)")
        print("items.count is \(items.count)")
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        print("You selected cell #\(indexPath.item)!")
        
        if indexPath.item == (items.count-1){
            items.append(items.last!+1)
//            print(items)
            collectionView.reloadData()
        }else{
            //ask for confirmation before remvpve(need to do)
            items.remove(at: indexPath.item)
//            print(items)
            collectionView.reloadData()
        }
        
        
        
    }
    
}

