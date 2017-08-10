//
//  Preference.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/10/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import Foundation

struct Preference {
    static var defaultInstance:Preference = Preference()
    
    var uri:String? = "rtmp://test:test@192.168.11.19/live"
    var streamName:String? = "live"
}
