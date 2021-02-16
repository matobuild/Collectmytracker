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
  
  var defaultIcon = "023-tyrannosaurus rex"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //                navigationItem.hidesBackButton = true
    navigationController?.setToolbarHidden(false, animated: true)
    
    if itemsArray.count == 0{
      initialiseItemsArray()
    }else{
      reloadData()
      totalCountingUpdateUI()
      
      let beforeLastPosition = itemsArray.count-1
      defaultIcon = itemsArray[beforeLastPosition].iconName ?? defaultIcon
    }
    
  }
  func initialiseItemsArray() {
    let startingItem = Item(context: self.context)
    startingItem.iconName = defaultIcon
    startingItem.parentTracker = selectedTracker
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
  }
  
  func addItem(icon: String) {
    let newItem = Item(context: self.context)
    newItem.iconName = icon
    newItem.parentTracker = selectedTracker
    itemsArray.append(newItem)
    saveItems()
    totalCountingUpdateUI()
    
    //        transitionAnimation()
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
    reloadData()
    
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
    reloadData()
  }
  
  func reloadData(){
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
  
  //pop over for adding choosing icon at the bottom
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
  func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
    popoverPresentationController.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
  }
}
extension ItemDataViewController:IconSelectionDelegate{
  func editTHeTapIconImage(stringIconNameChosen: String, atIndex: IndexPath) {
    //edit the selected image
    let position = atIndex.item
    itemsArray[position].iconName = stringIconNameChosen
    saveItems()
  }
  
  func didTapToIncreaseWithSeletectedImage(stringIconNameChosen: String) {
    //edit the last image icon before the last array
    editIconBeforeLastItem(icon: stringIconNameChosen)
    addItem(icon: stringIconNameChosen)
    defaultIcon = stringIconNameChosen
    print(itemsArray)
  }
  
  func editIconBeforeLastItem(icon: String){
    let beforeLastPosition = itemsArray.count-1
    itemsArray[beforeLastPosition].iconName = icon
    saveItems()
  }
}

//MARK: - creating the grid
extension ItemDataViewController: UICollectionViewDataSource,UICollectionViewDelegate{
  
  // MARK: - UICollectionViewDataSource protocol
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print("THE AMOUNT OF ITEMS IS \(itemsArray.count-1)")
    return itemsArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
    
    if indexPath.item == itemsArray.count-1{
      cell.myImage.image = UIImage(systemName: "hand.point.up")
    }else{
      if let iconName = self.itemsArray[indexPath.item].iconName{
        cell.myImage.image = UIImage(named: iconName)
      }
      
      
    }
    return cell
  }
  
  // MARK: - UICollectionViewDelegate protocol
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // handle tap events
    
    print("You selected cell #\(indexPath.item)!")
    print("items.count is \(itemsArray.count)")
    if indexPath.item == (itemsArray.count-1){
      addItem(icon: defaultIcon)
      print(itemsArray)
    }else{
      let confirmationToDelete = UIAlertController(title: "Are you sure wish to delete this icon?", message: "", preferredStyle: .actionSheet)
      let delete = UIAlertAction(title: "Delete", style: .destructive) { (delete) in
        self.deleteItem(at: indexPath)
      }
      let cancel = UIAlertAction(title: "Cancel", style: .cancel)
      
      confirmationToDelete.addAction(delete)
      confirmationToDelete.addAction(cancel)
      
      present(confirmationToDelete, animated: true, completion: nil)
      
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


