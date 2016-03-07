//
//  subjectTableViewController.swift
//  zhiHuDemo
//
//  Created by 胡胡赛军 on 2/25/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class subjectTableViewController: UITableViewController {
    
    var menuButton = UIBarButtonItem()
    var subjectID = 0
    var imageView = UIImageView()
    var imageLabel = UILabel()
    var imagesStrings = [String]()
    var tableViewCellTitles = [String]()
    var tableViewCellID = [Int]()
    //size
    let width = UIScreen.mainScreen().bounds.width
    let height  = UIScreen.mainScreen().bounds.height
    
    var addBtn = UIBarButtonItem()
    var deleteBtn = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        networkRequest()

        //configure menubutton
        menuButton.title = "Menu"
        self.navigationItem.leftBarButtonItem =  menuButton
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.0863, green: 0.4039, blue: 0.9725, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //SWRevealViewcontrolller adjust
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //UI configure 
        imageView.frame = CGRectMake(0, 0, width, 240)
        imageView.contentMode = .ScaleToFill
        
        imageLabel.numberOfLines = 2
        imageLabel.frame = CGRectMake(0, 200, width, 40)
        imageLabel.textAlignment = .Left
        imageLabel.textColor = UIColor(white: 0.9, alpha: 1)
        imageLabel.backgroundColor  = UIColor(white: 1, alpha: 0)
        
        imageView.addSubview(imageLabel)
        self.tableView.tableHeaderView = imageView
        tableView.rowHeight = 88
        tableView.separatorStyle = .SingleLineEtched
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.grayColor()
        self.clearsSelectionOnViewWillAppear = false
        //        tableView.separatorInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 10)
        //tableView.separatorColor = UIColor.blueColor()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        deleteBtn = UIBarButtonItem(barButtonSystemItem: .Undo, target: self, action: "deleteBtnClicked")
        addBtn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addBtnClicked")
        self.navigationItem.rightBarButtonItem = addBtn
        self.navigationItem.rightBarButtonItem = deleteBtn
    }
    
    
    // MARK : -- btn cliked func
    func addBtnClicked(){
        self.navigationItem.rightBarButtonItem = self.deleteBtn
    }
    
    func deleteBtnClicked(){
        self.navigationItem.rightBarButtonItem = self.addBtn

    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableViewCellID.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: myTableViewCell! = tableView.dequeueReusableCellWithIdentifier("myTableViewCell") as? myTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "myTableViewCell", bundle: nil), forCellReuseIdentifier: "myTableViewCell")
            cell = tableView.dequeueReusableCellWithIdentifier("myTableViewCell") as? myTableViewCell
        }
        
        let row = indexPath.row
        
        cell?.myLabel.text = tableViewCellTitles[row]
        cell?.myLabel.textAlignment  = .Left
        if imagesStrings[row] != "0"{
            cell?.myImageView?.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imagesStrings[row])!)!)
            
        }
        
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = detailViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
        detailVC.id = self.tableViewCellID[indexPath.row]
        detailVC.IDS = self.tableViewCellID
        
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
        let url = NSURL(string: "http://news-at.zhihu.com/api/4/theme/\(self.subjectID)")!
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    let stories =  json["stories"]
                    for i in 0...stories.count-1{
                        if json["stories",i,"images",0].string != nil{
                            let tmpString = json["stories",i,"images",0].stringValue
                            self.imagesStrings.append(tmpString)
                        }
                        if json["stories",i,"images",0] == nil
                        {
                            self.imagesStrings.append("0")
                        }
                        if let tmpTitle = json["stories",i,"title"].string{
                            self.tableViewCellTitles.append(tmpTitle)
                        }
                        if let tmpID = json["stories",i,"id"].int{
                            self.tableViewCellID.append(tmpID)
                        }
                        
                        
                    }
                    if let tmpLandscape = json["background"].string{
                        let imageData = NSData(contentsOfURL: NSURL(string: tmpLandscape)!)
                        self.imageView.image = UIImage(data: imageData!)
                    }
                    if let tmpdescription = json["description"].string{
                        self.imageLabel.text = tmpdescription
                    }
                    if let tmpName = json["name"].string{
                        self.navigationItem.title = tmpName
                    }
                    
                    
                    self.tableView.reloadData()
                }
            case .Failure(let error):
                print(error)
//                let errorView = UIView(frame: CGRectMake(0,0,self.width,self.height))
//                let tintLabel = UILabel()
//                tintLabel.center = CGPoint(x: self.width*0.5,y: self.height*0.5)
//                tintLabel.sizeThatFits(CGSize(width: 50, height: 100))
//                tintLabel.text = " you netWork may have some mistakes,please check"
//                tintLabel.numberOfLines = 2
//                errorView.addSubview(tintLabel)
//                self.view.addSubview(errorView)
//                self.view.bringSubviewToFront(errorView)
                var errorViewController = UIAlertController(title: "netWork mistakes", message: "please check you network settings", preferredStyle: .Alert)
                errorViewController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                self.presentViewController(errorViewController, animated: true, completion: nil)
            }
            
        }
        
    }
    
    
    
    
    
    
}//end
