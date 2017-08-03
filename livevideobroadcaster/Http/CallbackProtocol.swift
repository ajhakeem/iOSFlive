//
//  CallbackProtocol.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/2/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import Foundation

protocol callbackProtocol {
    
    mutating func onSuccess(response : JSONSerialization)
    
    func onError(isError : Bool)
    
}
