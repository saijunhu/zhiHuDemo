//
//  dataHandling.swift
//  zhiHuDemo
//
//  Created by 胡胡赛军 on 2/24/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


struct story {
    init(){
        title = ""
        images = []
        id = 0
        
    }
    var title :String
    var images = [String]()
    var id:Int
    
    
}

struct top_story {
    init(){
        title = ""
        images = ""
        id = 0
        
    }
    var title:String
    var images:String
    var id:Int
    
}


//network request
func netRequest(urlString:NSURL,jsonCallBack:(data: JSON) -> Void) -> Void{
    let queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT)
    dispatch_async(queue) { () -> Void in
        
    
        Alamofire.request(.GET, urlString).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    jsonCallBack(data: json)
                }
            case .Failure(let error):
                print(error)
                UIView.showAlertView("Sorry", message: "Please check you network settings")
            }
        }
    }
    
    
    
}//fune end













