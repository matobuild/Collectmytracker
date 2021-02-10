//
//  ViewController.swift
//  Collectmytracker
//
//  Created by kittawat phuangsombat on 2021/1/16.
//
//<div>Icons made by <a href="https://www.flaticon.com/authors/darius-dan" title="Darius Dan">Darius Dan</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
//

import UIKit
import CoreData

class ItemDataViewController: UIViewController {
    
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
        //                navigationItem.hidesBackButton = true
        navigationController?.setToolbarHidden(false, animated: true)
        
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
    @IBOutlet weak var counter: UIBarButtonItem!
    
    
    //MARK: - add & delete Items
    @IBAction func addCountPressed(_ sender: UIBarButtonItem) {
        showPopoverAction(sender)
//        addItem()
    }
    
    func addItem() {
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
        
        transitionAnimation()
    }
    func transitionAnimation() {
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        view.layer.add(transition, forKey: nil)
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
    
}
//MARK: - popovermenu for icon choice

extension ItemDataViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func showPopoverAction(_ sender: UIBarButtonItem){
        guard let imageDisplayViewController = storyboard?.instantiateViewController(withIdentifier: "ImageDisplayViewController") as? ImageDisplayViewController else {
            return
        }
        imageDisplayViewController.preferredContentSize = CGSize(width: 500, height: 130)
        imageDisplayViewController.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = imageDisplayViewController.popoverPresentationController!
        popover.delegate = self
        popover.sourceView = self.view
        popover.barButtonItem = sender
        imageDisplayViewController.selectionDelegate = self
        present(imageDisplayViewController, animated: true, completion:nil)
    }
    
}
extension ItemDataViewController:IconSelectionDelegate{
    func didTapIconChoice(stringIconNameChosen: String) {
        print(stringIconNameChosen)
        addItem()
    }
    
}

//MARK: - creating the grid
extension ItemDataViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
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
            cell.myImage.image = #imageLiteral(resourceName: "012-diplodocus")
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
            addItem()
        }else{
            //ask for confirmation before remove(need to do)
            deleteItem(at: indexPath)
            
        }
        saveItems()
    }
    
    func totalCountingUpdateUI() {
        counter.title = "Total : \(String(itemsArray.count-1))"
    }
    
}

//MARK: - hide toolbar while scrolling

extension ItemDataViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity (in: scrollView).y
        if velocity < -5 {
            //            self.navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.setToolbarHidden(true, animated: true)
        } else if velocity > 5 {
            //            self.navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.setToolbarHidden(false, animated: true)
        }
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            navigationController?.setToolbarHidden(false, animated: true)
        }
    }
    
    func scrollToBottom() {
        let lastIndex = IndexPath(item: self.itemsArray.count-1, section: 0)
        self.grid.scrollToItem(at: lastIndex, at: .centeredVertically, animated: true)
        
    }
    
}


