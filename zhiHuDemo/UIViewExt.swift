//
//  UIViewExt.swift
//  zhiHuDemo
//
//  Created by 胡胡赛军 on 3/7/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import Foundation



extension UIView{
    
    class func showAlertView(title: String,message: String){
        let alertView = UIAlertView()
        alertView.title = title
        alertView.message = message
        alertView.addButtonWithTitle("Got it")
        alertView.show()

    }
}