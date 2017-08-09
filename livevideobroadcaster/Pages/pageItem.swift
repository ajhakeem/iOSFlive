//
//  pageItem.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/6/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import Foundation

class pageItem : NSObject {
    var pageName : String
    var verified : Bool
    
    init(pageName : String, verified : Bool?) {
        self.pageName = pageName
        self.verified = verified!
        
        super.init()
    }
    
}
