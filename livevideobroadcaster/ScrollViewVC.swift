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
    
        cell.textLabel.text = textArray[indexPath.row]
        return cell
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
