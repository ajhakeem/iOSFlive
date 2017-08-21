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

    let const = Constants()
    var pageUrl : String = ""
    
    init() {
        self.pageUrl = const.PROD_ROOT_URL + const.PAGE_BASE_URI + const.GET_PAGES_URI
    }
    
    func getPageNames(authToken : String, completion : @escaping ((Array<AnyObject>?) -> ())) -> [String] {
        //URL(string: "https://testapi.fbfanadnetwork.com/pages/getAllPages.php")!
        
        var pageNameList = [String]()
    
        let mHeaders1 = [
            "Content-Type" : "application/form-data",
            "X-Client" : "Mobile",
            "Authorization" : authToken
        ]
        
        Alamofire.request(URL(string: self.pageUrl)!, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: mHeaders1)
        .responseJSON { (response) in
            if (response != nil) {
                if let responseArray = response.result.value as? NSArray {
                    if (responseArray.count > 1) {
                        for index in 0...responseArray.count-1 {
                            var arrayObject = responseArray[index] as! [String : AnyObject]
                            if ((arrayObject["verified"] as? String) == "1") {
                             pageNameList.append(arrayObject["name"] as! String)   
                            }
                        } //end foreach
                        completion(pageNameList as Array<AnyObject>)
                    }
                    
                    else {
                        completion(nil)
                    }
                } //end create response jsonArray
            } //end response nil check
            
            else {
                completion(nil)
            }
            //print(pageNameList)
        } //end Alamofire request
        return pageNameList
    } //end getPages()

    func getPageDetails(authToken : String, pageName : String, completion : @escaping ([String : Any]?) -> ()) {
        
        let mHeaders = [
            "Content-Type" : "application/form-data",
            "X-Client" : "Mobile",
            "Authorization" : authToken
        ]
        
        Alamofire.request(URL(string: self.pageUrl)!, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: mHeaders)
        .responseJSON { (response2) in
            if (response2 != nil) {
                if let responseArray = response2.result.value as? NSArray {
//                    print(responseArray)
                    for index in 0...responseArray.count-1 {
//                        print("RESPONSE ARRAY TYPE")
//                        print(type(of: responseArray))
                        var arrayObject = responseArray[index] as! [String : Any]
                        let arrName = arrayObject["name"] as! String
                        if (arrName == pageName) {
                            let keyExists : Bool = true
                            if (keyExists == true) {
//                                print(arrayObject)
                                completion(arrayObject)
                            }
                        }
                    }
                }
            }
            
            else {
                completion(nil)
            }
        }
    }
}
