//
//  Pages.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/4/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import Foundation
import Alamofire

class Pages : http {
    
    var pageNames : [String] = []
    
    func getPageNames() -> [String] {
        //URL(string: "https://testapi.fbfanadnetwork.com/pages/getAllPages.php")!
        
        let mHeaders = [
            "Content-Type" : "application/form-data",
            "X-Client" : "Mobile",
            "Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjQiLCJlbWFpbCI6InNhbGVlbUBmYW5hZG5ldHdvcmsuY29tIiwidHlwZSI6InB1Ymxpc2hlciIsImhhc19zb2NpYWxfYWNjb3VudCI6MSwiaGFzX3BhZ2VzIjoxLCJpc1N1c3BlbmRlZCI6MCwiZXhwIjoxNTMzNjEyMjcyLCJyb2xlIjoidXNlciJ9.ylJ7-gKrG4ekfG2J_fPoP9OYU5ih1BGHcrSqQK3gJ94"
        ]
        
        Alamofire.request(URL(string: "https://testapi.fbfanadnetwork.com/pages/getAllPages.php")!, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: mHeaders)
        .responseJSON { (response) in
            if (response != nil) {
                if let responseArray = response.result.value as? NSArray {
                    for index in 0...responseArray.count-1 {
                        let arrayObject = responseArray[index] as! [String : AnyObject]
                        self.pageNames.append(arrayObject["name"] as! String)
                        print(self.pageNames)
                    } //end foreach
                } //end create response jsonArray
            } //end response nil check
        } //end Alamofire request
        
        return pageNames
    } //end getPages()
}
