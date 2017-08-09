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
    
    func setUserToken(userToken : String) {
        self.userToken = userToken
    }
    
    func getUserToken() -> String {
        return self.userToken
    }
}
