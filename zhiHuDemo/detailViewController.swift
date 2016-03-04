//
//  detailViewController.swift
//  zhiHuDemo
//
//  Created by 胡胡赛军 on 2/25/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class detailViewController: UIViewController ,UIWebViewDelegate,UIScrollViewDelegate{
    
    var detailTitle = ""
    //UI size
    let width = UIScreen.mainScreen().bounds.width
    let height  = UIScreen.mainScreen().bounds.height
    
    
    var id = 0{
        didSet{
            
            if self.id != 0{
                url = NSURL(string: "http://news-at.zhihu.com/api/4/news/\(id)")!
                extraURL = NSURL(string: "http://news-at.zhihu.com/api/4/story-extra/\(id)")!
                networkRequest()
            }
        }
    }
    
    var IDS = [Int]()
    var webView = UIWebView()
    var url = NSURL()
    var extraURL = NSURL()
    var imageView = UIImageView()
    var titleLabel = UILabel()
 
    var commentBtn = UIBarButtonItem()
    var praiseBtn = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let socialBtn = UIBarButtonItem(title: "social", style: .Plain, target: self, action: "socialBtnClicked")
        let starBtn = UIBarButtonItem(title: "star", style: .Plain, target: self, action: "starBtnClicked")
        commentBtn = UIBarButtonItem(title: "comment", style: .Plain, target: self, action: "commentBtnClicked")
        praiseBtn = UIBarButtonItem(title: "praise", style: .Plain, target: self, action: "praiseBtnClicked")
        
        let NavBtn = [praiseBtn,commentBtn,starBtn,socialBtn]
        
        self.navigationItem.rightBarButtonItems = NavBtn
 
   
        //imageView
        imageView.frame = CGRectMake(0, 0, width, 200)
        imageView.backgroundColor = UIColor.grayColor()
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.clipsToBounds = true
        
        //imageLabel
        let imageLabel = UILabel(frame: CGRectMake(width*0.5,180,width*0.5,20))
        imageLabel.text = "ⓒsaijun Hu"
        imageLabel.textAlignment = .Right
        imageLabel.backgroundColor = UIColor(white:1, alpha: 0)
        imageLabel.textColor = UIColor(white: 0.8, alpha: 1)
        
        //titleLalel
        titleLabel.frame = CGRectMake(10, 120, width, 60)
        titleLabel.backgroundColor = UIColor(white: 1, alpha: 0)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Left
        titleLabel.numberOfLines = 3
        
        
        //webView
        webView = UIWebView(frame: CGRectMake(0,0,width,height))
        self.webView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.webView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin
        webView.scalesPageToFit = false
        webView.delegate = self

        //view layer
        imageView.addSubview(imageLabel)
        imageView.addSubview(titleLabel)
        self.webView.scrollView.addSubview(imageView)
        //webView.scrollView.addSubview(titleLabel)
        self.view.addSubview(webView)
        
        //Gesture
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        swipeLeftGesture.direction = .Left
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        swipeRightGesture.direction = .Right
        self.view.addGestureRecognizer(swipeRightGesture)
        // Do any additional setup after loading the view.
    }
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
       
        if navigationType == .LinkClicked{
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
            
        }
        return true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -200{
            self.navigationController?.navigationBarHidden = true
        }
        if scrollView.contentOffset.y > -200 {
            self.navigationController?.navigationBarHidden = false
        }
    }

   //MARK: -selector func
    
    
    func swipeLeft(){
        // load the next article
        NSLog("swipe left")
        var tmpIndex = self.IDS.indexOf(self.id)! as Int
        if tmpIndex != self.IDS.count-1{
            
            self.id = self.IDS[++tmpIndex]
        }
        
        
    }
    
    func swipeRight(){
        NSLog("swipe right ")
        var tmpIndex  = self.IDS.indexOf(self.id)! as Int
        if tmpIndex != 0{
            self.id = self.IDS[--tmpIndex]
        }
    }
    
    func socialBtnClicked(){
        
    }
    
    func starBtnClicked(){
        
    }
    
    func commentBtnClicked(){
        //
        
    }
    
    func praiseBtnClicked(){
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func networkRequest(){
        
       //get the news info
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    //handle
                    let title = json["title"].stringValue
                    //adjust the title spacing
                    let attributedString = NSMutableAttributedString(string: title)
                    attributedString.addAttribute(NSKernAttributeName, value: CGFloat(5), range: NSRange(location: 0, length: title.characters.count))
                    
                    self.titleLabel.attributedText = attributedString
                    let cssURL = json["css",0].stringValue
                    self.webView.loadRequest(NSURLRequest(URL: NSURL(string: cssURL)!))
                    
                    let body = json["body"].stringValue
                    let htmlCssStirng = "<html><head><link rel=\"stylesheet\" href=\(cssURL)></head><body>\(body)</body></html>"
                    self.webView.loadHTMLString(htmlCssStirng, baseURL: nil)
//                    NSString *html = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>", [self.dataModel.cssArray objectAtIndex:0], self.dataModel.bodyHtmlStr];
//                    [self.backWebView loadHTMLString:html baseURL:nil];
                    if let imageURL = json["image"].string{
                    let imageData = NSData(contentsOfURL: NSURL(string: imageURL)!)
                    self.imageView.image = UIImage(data: imageData!)
                    }
                    
                    if json["image"].string == nil {
                        self.imageView.removeFromSuperview()
                        self.titleLabel.removeFromSuperview()
                        self.webView.frame.origin = CGPointZero
                    }
                    //let id  = json["id"]
                    
                    
                }
            

            case .Failure(let error):
                print(error)
            }
        }
        
        //get the extra info
       
        Alamofire.request(.GET, self.extraURL).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
//                {"post_reasons":0,"long_comments":0,"popularity":104,"normal_comments":13,"comments":13,"short_comments":13}
                    if let longComment = json["long_comments"].int{
                        //self.
                    }
                    if let shortComment = json["short_comments"].int{
                        
                    }
                    if let comments = json["comments"].int{
                        self.commentBtn.title = "C \(comments)"
                    }
                    if let praise = json["popularity"].int{
                        
                       self.praiseBtn.title = "P \(praise)"
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
        
        
        
    }
    
    
    
    
    
    
}
