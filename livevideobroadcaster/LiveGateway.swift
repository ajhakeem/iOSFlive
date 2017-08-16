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
        self.reqUrl = const.ROOT_URL + const.BASE_URI + const.GET_STREAM_KEY_URI
    }
    
//    ["page_id":selectedPageId]
//    completion : @escaping (_ success : Bool) -> ()
    func getStreamKey(authToken : String, selectedPageId : String, completion: @escaping ((String)?) -> ()) {

        let mHeaders = [
            "Content-Type" : "application/form-data",
            "X-Client" : "Mobile",
            "Authorization" : authToken
        ]
    
        Alamofire.request(URL(string: self.reqUrl)!, method: .get, parameters: ["page_id" : selectedPageId], encoding: URLEncoding.default, headers: mHeaders)
        .responseJSON { (response) in
            switch response.result {
            case .success( _):
                let values = response.result.value as! [String: AnyObject]
                let valueInfo = values["data"] as! [String : String]
                let streamKey = valueInfo["stream_key"]!
                completion(streamKey)
                break
                
            case .failure(let errorGiven):
                print(errorGiven)
                completion(nil)
        
            }
    
            
            /*switch response.result {
            case .success(let retrievedResult):
                print("RETRIEVED RESULT")
                print(retrievedResult)
                //completion(retrievedResult as! String)
                break
            case .failure(let errorGiven):
                print(errorGiven)
                print(String(data: response.data!, encoding: String.Encoding.utf8) ?? "")
                //completion(nil)
                break
            }*/
        }
    }
}
