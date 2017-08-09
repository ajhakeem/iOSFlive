//
//  Pages.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/4/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import Foundation
import Alamofire

class Pages {
    
    func getPageNames(authToken : String, completion : @escaping ((Array<AnyObject>?) -> ())) -> [String] {
        //URL(string: "https://testapi.fbfanadnetwork.com/pages/getAllPages.php")!
        
        var pageNameList = [String]()
        
        let mHeaders1 = [
            "Content-Type" : "application/form-data",
            "X-Client" : "Mobile",
            "Authorization" : authToken
        ]
        
        Alamofire.request(URL(string: "https://testapi.fbfanadnetwork.com/pages/getAllPages.php")!, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: mHeaders1)
        .responseJSON { (response) in
            if (response != nil) {
                if let responseArray = response.result.value as? NSArray {
                    //print(responseArray)
                    for index in 0...responseArray.count-1 {
                        let arrayObject = responseArray[index] as! [String : AnyObject]
                        pageNameList.append(arrayObject["name"] as! String)
                    } //end foreach
                    completion(pageNameList as Array<AnyObject>)
                } //end create response jsonArray
            } //end response nil check
            
            else {
                completion(nil)
            }
            //print(pageNameList)
        } //end Alamofire request
        return pageNameList
    } //end getPages()

}
