//
//  LiveGateway.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/12/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import Foundation
import Alamofire

class LiveGateway {
    
    let const = Constants()
    var reqUrl : String = ""
    
    init() {
        self.reqUrl = const.PROD_ROOT_URL + const.BASE_URI + const.GET_STREAM_KEY_URI
    }
    
//    ["page_id":selectedPageId]
//    completion : @escaping (_ success : Bool) -> ()
    func getStreamKey(authToken : String, selectedPageId : String) {

        let mHeaders = [
            "Content-Type" : "application/form-data",
            "X-Client" : "Mobile",
            "Authorization" : authToken
        ]
        
        print("STREAM KEY PRINT")
        print(reqUrl)
//        
//        Alamofire.request(URL(string: self.pageUrl)!, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: mHeaders)
//            .responseJSON { (response2) in
//                if (response2 != nil) {

        Alamofire.request(URL(string: self.reqUrl)!, method: .get, parameters: ["page_id":selectedPageId], encoding: JSONEncoding.prettyPrinted, headers: mHeaders)
        .validate()
        .responseData { (response3) in
            print("RESPONSE PRINT")
            print(response3)
        }
    
    }
}
