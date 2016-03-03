//
//  launchViewController.swift
//  zhiHuDemo
//
//  Created by 胡胡赛军 on 2/24/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

class launchViewController: UIViewController {
    
    var imageURL:String!
    //
    let width = UIScreen.mainScreen().bounds.width
    let height  = UIScreen.mainScreen().bounds.height
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let imageView  = UIImageView(frame: CGRectMake(0,0,width,height))
        let textLabel = UILabel(frame: CGRectMake(0,height-20,width,20 ))
        
        textLabel.text = "ⓒ saijun Hu "
        textLabel.textAlignment = .Center
        
        let url = NSURL(string: "http://news-at.zhihu.com/api/4/start-image/1080*1776")
        
        Alamofire.request(.GET,url!).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if let tmpURL = json["img"].string{
                        self.imageURL = tmpURL
                        NSLog("@", self.imageURL)
                    }
                    print("JSON: \(json)")
                }
                let imageData = NSData(contentsOfURL: NSURL(string: self.imageURL)!)
                imageView.image = UIImage(data: imageData!)
                imageView.contentMode = .ScaleAspectFill
            case .Failure(let error):
                print(error)
            }
        }
        
        
        
        
        self.view.addSubview(imageView)
        self.view.addSubview(textLabel)
        
    }
//    override func viewWillDisappear(animated: Bool) {
//        let VC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("containerVC")
//        sleep(10)
//        //self.showViewController(VC, sender: nil)
//        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appdelegate.window?.rootViewController = VC
//    }
//    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
