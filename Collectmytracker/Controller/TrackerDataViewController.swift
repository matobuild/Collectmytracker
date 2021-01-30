//
//  ViewController.swift
//  Collectmytracker
//
//  Created by kittawat phuangsombat on 2021/1/16.
//
//<div>Icons made by <a href="https://www.flaticon.com/authors/darius-dan" title="Darius Dan">Darius Dan</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>


import UIKit
import CoreData

class TrackerDataViewController: UIViewController {
    
    var itemsArray = [Item]()
    
    var selectedTracker : Tracker?{
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        navigationItem.hidesBackButton = true
        
        let startingItem = Item(context: self.context)
        startingItem.amount = 0
        itemsArray.append(startingItem)
        saveItems()
        totalCountingUpdateUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectedTracker!.name
        
    }
    
    @IBOutlet weak var grid: UICollectionView!
    @IBOutlet weak var countLabel: UILabel!
    
    
    //MARK: - add & delete Items
    
    @IBAction func addCountPressed(_ sender: UIButton) {
        
        let newItem = Item(context: self.context)
        newItem.amount = 1 + itemsArray.last!.amount
        newItem.parentTracker = self.selectedTracker
        itemsArray.append(newItem)
        saveItems()
        totalCountingUpdateUI()
    }
    
    func deleteItem(at indexPath: IndexPath) {
        context.delete(itemsArray[indexPath.item])
        itemsArray.remove(at: indexPath.item)
        totalCountingUpdateUI()
        grid.reloadData()
       
    }
    
    //MARK: - Model Manipulation Methods
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        DispatchQueue.main.async {
            self.grid.reloadData()
            self.scrollToBottom()
        }
        
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let trackerPredicate = NSPredicate(format: "parentTracker.name MATCHES %@", selectedTracker!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [trackerPredicate,additionalPredicate])
        }else{
            request.predicate = trackerPredicate
        }
        
        do{
            itemsArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        DispatchQueue.main.async {
            self.grid.reloadData()
            self.scrollToBottom()
        }
        
    }
    func scrollToBottom() {
        let lastIndex = IndexPath(item: self.itemsArray.count-1, section: 0)
        self.grid.scrollToItem(at: lastIndex, at: .centeredVertically, animated: true)
        
    }
}


//MARK: - creating the grid
extension TrackerDataViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("THE AMOUNT OF ITEMS IS \(itemsArray.count)")
        return itemsArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //        cell.myLabel.text = String(self.items[indexPath.row])// The row value is the same as the index of the desired text within the array.
        if indexPath.item == itemsArray.count-1{
            cell.myImage.image = #imageLiteral(resourceName: "023-tyrannosaurus rex")
        }else{
            cell.myImage.image = #imageLiteral(resourceName: "bored-1")
        }
        //        print("idexpath. item is \(indexPath.item)")
        //        print("items.count is \(items.count)")
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        print("You selected cell #\(indexPath.item)!")
        print("items.count is \(itemsArray.count)")
        if indexPath.item == (itemsArray.count-1){
            
  /*
   should open another view to choose the icon,
   */
            
            addCountPressed(UIButton())
            
        }else{
            //ask for confirmation before remove(need to do)
            deleteItem(at: indexPath)
            
        }
        saveItems()
    }
    
    func totalCountingUpdateUI() {
        countLabel.text = "Total : \(String(itemsArray.count-1))"
        
    }

   
}


