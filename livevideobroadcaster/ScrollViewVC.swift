//
//  ScrollViewVC.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/3/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import UIKit

class ScrollViewVC: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageArray = [#imageLiteral(resourceName: "flive_splash"), #imageLiteral(resourceName: "flive_logo")]
        
        for i in 0 ..< imageArray.count {
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleAspectFit
            let xPos = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
            
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i + 1)
            //mainScrollView.addSubview(imageView)
        }
        
        let pageObject = Pages()
        let _ = pageObject.getPageNames()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
