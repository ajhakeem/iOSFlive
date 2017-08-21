//
//  CVTestVC.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/20/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import Foundation
import UIKit

class cvTestVC : UIViewController {
    let leftAndRightPaddings: CGFloat = 80.0
    let numberOfItemsPerRow: CGFloat = 7.0
    let screenSize: CGRect = UIScreen.main.bounds
    var collectionView : UICollectionView!
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items.append("hi")
        self.items.append("hey")
        self.items.append("sup")
        self.items.append("hola")
        self.items.append("hello")
        setupCV()
    }

    func setupCV() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self , forCellWithReuseIdentifier: "blogCell")
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
}

extension cvTestVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "blogCell", for: indexPath) as! ImageCollectionViewCell
        
        let cellImage = UIImage(named: "page_select_background")!
        let highlightedCellImage = UIImage(named: "page_select_background_selected")!
        
        print("ITEMS PRINT")
        print(items[indexPath.row])
//        cell.textLabel.text = items[indexPath.row]
//        cell.imageViewCell.image = cellImage
//        cell.imageViewCell.highlightedImage = highlightedCellImage
//        cell.textLabel.highlightedTextColor = UIColor.white
//        cell.imageViewCell.layer.cornerRadius = 15.0
//        cell.imageViewCell.clipsToBounds = true
        
        cell.contentView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.contentView.layer.shadowRadius = 7.5
        cell.contentView.layer.shadowOpacity = 1.0
        cell.contentView.clipsToBounds = true

        cell.awakeFromNib()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let blogCell = cell as! ImageCollectionViewCell
//        blogCell.textLabel.text = items[indexPath.row]
        blogCell.imageViewCell.image = UIImage(named: "liveButton")
    }
}
