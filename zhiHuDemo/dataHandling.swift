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














