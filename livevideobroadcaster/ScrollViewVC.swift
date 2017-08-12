//
//  ScrollViewVC.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/3/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import UIKit
import Alamofire

class ScrollViewVC : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    /*@IBOutlet weak var mainScrollView: UIScrollView!
    var imageArray = [UIImage]()*/
//    weak var backButton : UIButton!
    
    var pageObject = Pages()
    @IBOutlet weak var collectionViewCell: ImageCollectionViewCell!
    var passedToken : String = "Bearer "
    var viewcell = ImageCollectionViewCell()
    let const = Constants()
    var token = Token()
    var viewCell = ImageCollectionViewCell()
    var currentCell : String = ""

    @IBOutlet weak var collectionView: UICollectionView!
    
    var textArray = [String]()
    var selectedPageDetails = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrievePages()
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        shareLink(shareCompletion: { (response) in
            if (response == true) {
                print("Successfully shared!")
            }
            
            else {
                print("Could not share now!")
            }
        })
    }
    
    func shareLink(shareCompletion : @escaping (_ success : Bool) -> ()) {
        var headers = const.mHeaders
        headers["Authorization"] = passedToken
        let messageParams = [
            "194300524348319" : "page_id",
            "http://hoc.fanadnetwork.com/live" : "link",
            "This is a test" : "message"]
        
        //        "194300524348319" : "page_id",
        //        "http://hoc.fanadnetwork.com/live" : "link",
        //        "This is a test" : "message"
        
        let reqUrl = const.ROOT_URL + const.BASE_URI + const.SHARE_LINK_URI

        Alamofire.request(URL(string: reqUrl)!, method: .get, parameters: messageParams, encoding: JSONEncoding.prettyPrinted, headers: headers)
            .responseJSON { (response) in
                    if let responseArray = response.result.value as? NSArray {
                        print(responseArray)
                        for ind in 0...responseArray.count-1 {
                            let arrayObject = responseArray[ind] as! [String : AnyObject]
                            print(arrayObject)
                        }
                        shareCompletion(true)
                    }
                
                    else {
                        shareCompletion(false)
                }
        }
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
        
        let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell
        self.currentCell = (cell?.textLabel.text!)!
//        print(self.currentCell)
        
        pageObject.getPageDetails(authToken: passedToken, pageName: currentCell, completion: { (detailPage) in
            if (detailPage != nil) {
                print("Succeeded in retrieving detail page")
                self.selectedPageDetails = detailPage!
                self.goLive()
            }
                
            else {
                print("Detail Page failed")
            }
        })
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
    
    func goLive() {
        if (selectedPageDetails.count > 0) {
            let selectedPageBlogUrl = selectedPageDetails["blog_url"] as! String
            let selectedPageVerified = selectedPageDetails["verified"] as! String
            if ((selectedPageVerified == "1") && (selectedPageBlogUrl != nil) && (!selectedPageBlogUrl.isEmpty)) {
                print("PAGE VERIFIED, BLOG URL NOT NIL, BLOG URL")
                
                //FILL IN HERE 
            }
        }
    }
    
    
}
