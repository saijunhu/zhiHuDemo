//
//  UIImageViewExt.swift
//  zhiHuDemo
//
//  Created by 胡胡赛军 on 3/7/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import Foundation

extension UIImageView{
    
    func getImageWithURL(urlString: String){
        let URL = NSURL(string: urlString)!
        let imageData = NSData(contentsOfURL: URL)
        let myImage = UIImage(data: imageData!)
        self.image = myImage
    }
    
}