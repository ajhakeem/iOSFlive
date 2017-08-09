//
//  http.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/2/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import Foundation

class http {
    let ROOT_URL : String = "https://testapi.fbfanadnetwork.com"
    let RETURNS_ARRAY : Bool = true
    
    var mHeaders = [String : String]()
    
    init() {
        mHeaders["Content-Type"] = "application/form-data"
        mHeaders["X-Client"] = "Mobile"
    }
    
}
