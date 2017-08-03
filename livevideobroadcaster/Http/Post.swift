//
//  Post.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/2/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import Foundation

class Post : http {
    
    override init() {
        super.init()
    }

    var handlerBlock : (Bool) -> Void = { input in
        if (input) {
            print("Input is true")
        }
            
        else {
            print("Input is false")
        }
    }
    
    
}
