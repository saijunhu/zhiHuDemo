//
//  menuTableViewController.swift
//  zhiHuDemo
//
//  Created by 胡胡赛军 on 2/24/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class menuTableViewController: UITableViewController {
    
    //size
    let width = UIScreen.mainScreen().bounds.width
    let height  = UIScreen.mainScreen().bounds.height
    var menuWidth:CGFloat!
    var subjects = [String]()
    var subScribed = []
    var mainVC = UINavigationController()
    var subjectsID = [Int]()
    var subjectDetailID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkRequest()
        //
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        self.mainVC = storyboard.instantiateViewControllerWithIdentifier("mainVC") as! UINavigationController
        //
        self.revealViewController().rearViewRevealWidth = width*0.8
        menuWidth = self.revealViewController().rearViewRevealWidth
        
        let favoriteBtn = UIButton(frame: CGRectMake(0,60,menuWidth*0.5,40))
        //favoriteBtn.backgroundColor = UIColor.grayColor()
        favoriteBtn.setTitle("我的收藏", forState: .Normal)
        favoriteBtn.addTarget(self, action: "favoriteBtnClicked", forControlEvents: .TouchUpInside)
        
        let downloadBtn = UIButton(frame: CGRectMake(menuWidth*0.5,60,width*0.5,40))
        downloadBtn.setTitle("离线下载", forState: .Normal)
        //downloadBtn.backgroundColor = UIColor.grayColor()
        downloadBtn.addTarget(self, action: "downloadBtnClicked", forControlEvents: .TouchUpInside)
        
        let homeBtn = UIButton(frame: CGRectMake(0,100,menuWidth,44))
        homeBtn.setTitle("🏠 首页", forState: .Normal)
        homeBtn.titleLabel?.textAlignment = .Left
        homeBtn.addTarget(self, action: "homeBtnClicked", forControlEvents: .TouchUpInside)
        
        
        let headerView = UIView(frame: CGRectMake(0,0,menuWidth,144))
        headerView.backgroundColor = UIColor(red: 0.0863, green: 0.4039, blue: 0.9725, alpha: 1.0)
        headerView.addSubview(favoriteBtn)
        headerView.addSubview(downloadBtn)
        headerView.addSubview(homeBtn)
        
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = UIColor.grayColor()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    func homeBtnClicked(){
        NSLog("dsfsdf")
        
        
        let segue = SWRevealViewControllerSeguePushController(identifier: "home", source: self, destination: self.mainVC) { () -> Void in
            self.showViewController(self.mainVC, sender: nil)
        }
        segue.perform()
        
        
    }
    func downloadBtnClicked(){
        
    }
    
    func favoriteBtnClicked(){
        
    }
    func networkRequest(){
        let url = NSURL(string: "http://news-at.zhihu.com/api/4/themes")
        Alamofire.request(.GET, url!).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    //subscribed handle
                    let tmpJSON = json["subscribed"]
                    if tmpJSON.count > 0 {
                        for i in 0...tmpJSON.count-1{
                            var tmp =  json["subscribed",i]
                            
                            //var ?.append(tmp)
                        }
                    }
                    
                    let tmpOthersJSON = json["others"]
                    for i in 0...tmpOthersJSON.count-1{
                        if let tmp = json["others",i,"name"].string{
                            self.subjects.append(tmp)
                            NSLog("\(self.subjects.count)")
                        }
                        if let tmpID = json["others",i,"id"].int{
                            self.subjectsID.append(tmpID)
                        }
                    }
                   
                }
            self.tableView.reloadData()
            case .Failure(let error):
                print(error)
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
     
        return subjects.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath)
        
        let row = indexPath.row
        
        cell.textLabel?.text = self.subjects[row]
        cell.detailTextLabel?.text = "+"
        cell.detailTextLabel?.textColor = UIColor.blueColor()
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 25)
        
        return cell
        
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let subjectDetailVC = UINavigationController(rootViewController: subjectTableViewController())
        let subjectDetailSegue = SWRevealViewControllerSeguePushController(identifier: "subjectDetail", source: self, destination: subjectDetailVC) { () -> Void in
            self.showViewController( self, sender: nil)
        }
        self.subjectDetailID = self.subjectsID[indexPath.row]
        subjectDetailSegue.perform()
        prepareForSegue(subjectDetailSegue, sender: nil)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "subjectDetail"{
            let VC = segue.destinationViewController as! UINavigationController
            let detailVC = VC.topViewController as! subjectTableViewController
             detailVC.subjectID = self.subjectDetailID
    }


}
    
}//end