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
    let PROD_ROOT_URL = "https://fbfanads.com/fanads-backend"
    let LOGIN_PATH = "/users/login.php"
    let PAGE_BASE_URI = "/pages"
    let BASE_URI = "/pages/live"
    let GET_PAGES_URI = "/getAllPages.php"
    let TERMS_OF_USE_URL = "https://www.fanstories.co/terms.html"
    let PRIVACY_POLICY_URL = "https://www.fanstories.co/privacy.html"
    let GET_STREAM_KEY_URI = "/getStreamKey.php"
    let SHARE_LINK_URI = "/shareLink.php"
    let WEBSOCKET_URI = "ws://analytics.fanadnetwork.com/ws"
    var userToken = ""
    
    let TERMS_AND_POLICIES_AGREEMENT = "I have read and agree to the Terms of Use and Privacy Policy"
    
    var mHeaders = [
        "Content-Type" : "application/form-data",
        "X-Client" : "MOBILE"
    ]
    
    
    
    
}
