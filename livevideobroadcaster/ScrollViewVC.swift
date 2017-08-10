//
//  ScrollViewVC.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/3/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import UIKit

class ScrollViewVC : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    /*@IBOutlet weak var mainScrollView: UIScrollView!
    var imageArray = [UIImage]()*/
//    weak var backButton : UIButton!
    
    var pageObject = Pages()
    @IBOutlet weak var collectionViewCell: ImageCollectionViewCell!
    var passedToken : String = "Bearer "
    var viewcell = ImageCollectionViewCell()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var textArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrievePages()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        let cellImage = UIImage(named: "page_select_background")!
        let highlightedCellImage = UIImage(named: "page_select_background_selected")!
        
        cell.textLabel.text = textArray[indexPath.row]
        cell.viewCellImage.image = cellImage
        cell.viewCellImage.highlightedImage = highlightedCellImage
        cell.textLabel.highlightedTextColor = UIColor.white
        cell.viewCellImage.layer.cornerRadius = 15.0
        cell.viewCellImage.clipsToBounds = true
        
        cell.contentView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.contentView.layer.shadowRadius = 7.5
        cell.contentView.layer.shadowOpacity = 1.0
        cell.contentView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currentCell = collectionView.cellForItem(at: indexPath)
        print(currentCell)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrievePages() {
        self.textArray = pageObject.getPageNames(authToken: passedToken, completion: { (arrayResponse) in
            if ((arrayResponse?.count)! > 0) {
                print("Succeeded in retrieving")
                self.textArray = arrayResponse! as! [String]
                self.collectionView.reloadData()
            }
            
            else {
                print("Failed to retrieve")
            }
        })
    }
    
    
}
