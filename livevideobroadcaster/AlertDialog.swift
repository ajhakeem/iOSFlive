//
//  AlertDialog.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/10/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import Foundation
import UIKit

func alertUser(title : String, message : String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (action) in
        alert.dismiss(animated: true, completion: nil)
    }))
    
    return alert
    //self.present(alert, animated: true, completion: nil)
}
