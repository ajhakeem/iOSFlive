//
//  Token.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/8/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import Foundation

class Token {
    var userToken = String()
    var bearerUserToken = "Bearer "
    
    func setUserToken(userToken : String) {
        self.userToken = userToken
    }
    
    func getUserToken() -> String {
        return self.userToken
    }
    
    func setBearerUserToken(bearerUserToken : String) {
        self.bearerUserToken += bearerUserToken
    }
    
    func getBearerUserToken() -> String {
        return self.bearerUserToken
    }
}
