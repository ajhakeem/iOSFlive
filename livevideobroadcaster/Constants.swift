//
//  Constants.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/9/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import Foundation

struct Constants {
    let ROOT_URL = "https://testapi.fbfanadnetwork.com"
    let LOGIN_PATH = "/users/login.php"
    let PAGE_BASE_URI = "/pages"
    let GET_PAGES_URI = "/getAllPages.php"
    let TERMS_OF_USE_URL = "https://www.fanstories.co/terms.html"
    let PRIVACY_POLICY_URL = "https://www.fanstories.co/privacy.html"
    
    let TERMS_AND_POLICIES_AGREEMENT = "I have read and agree to the Terms of Use and Privacy Policy"
    
    var mHeaders = [
        "Content-Type" : "application/form-data",
        "X-Client" : "MOBILE"
    ]
    
    
    
    
}
