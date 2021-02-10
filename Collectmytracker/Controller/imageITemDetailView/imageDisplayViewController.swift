//
//  imageDisplayViewController.swift
//  Collectmytracker
//
//  Created by kittawat phuangsombat on 2021/1/31.
//

import UIKit

protocol IconSelectionDelegate {
    func didTapIconChoice(stringIconNameChosen : String)
}

class ImageDisplayViewController: UIViewController {
    
    var selectionDelegate : IconSelectionDelegate!

    private let reuseIdentifierImageCell = "imageCell"
    private let iconsChoice = ["001-stegosaurus"
                               ,"002-dinosaur"
                               ,"003-dinosaur"
                               ,"004-diplodocus"
                               ,"005-pterodactyl"
                               ,"006-diplodocus"
                               ,"007-dinosaur"
                               ,"008-diplodocus"
                               ,"009-stegosaurus"
                               ,"010-stegosaurus"
                               ,"011-dinosaur"
                               ,"012-diplodocus"
                               ,"013-pterodactyl"
                               ,"014-dinosaur"
                               ,"015-pterodactyl"
                               ,"016-dinosaur"
                               ,"017-dinosaur"
                               ,"018-dinosaur"
                               ,"019-dinosaur"
                               ,"020-pterodactyl"
                               ,"021-dinosaur"
                               ,"022-stegosaurus"
                               ,"023-tyrannosaurus rex"
                               ,"024-dinosaur"
                               ,"025-pterodactyl"
                               ,"026-triceratops"
                               ,"027-diplodocus"
                               ,"028-dinosaur"
                               ,"029-dinosaur"
                               ,"030-dinosaur"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(true, animated: true)
        
    }
    @IBOutlet weak var iconGrid: UICollectionView!
    
    
}
//MARK: - creating image to choose grid

extension ImageDisplayViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconsChoice.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierImageCell, for: indexPath as IndexPath) as! ImageIconCollectionViewCell
        
        cell.myIcon.image = UIImage(named: self.iconsChoice[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //put the string name inside the delegate
        selectionDelegate.didTapIconChoice(stringIconNameChosen: iconsChoice[indexPath.item])
        
//        iconsChoice[indexPath.item])
        dismiss(animated: true, completion:nil)
    }
    
    
}



