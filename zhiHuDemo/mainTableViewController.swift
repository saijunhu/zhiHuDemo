//
//  mainTableViewController.swift
//  zhiHuDemo
//
//  Created by 胡胡赛军 on 2/24/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDCycleScrollView
import SDWebImage
import MJRefresh

class mainTableViewController: UITableViewController ,SDCycleScrollViewDelegate{

    @IBOutlet weak var menuButton: UIBarButtonItem!
    

    var allDates = [String]()
    var allStoriesImages = [[String]]()
    var allStoriesID = [[Int]]()
    var allStoriesTitles = [[String]]()
    
    var forDetailIDS = [Int]()
    
    //cycleImageView relevent
    var top_stories = [top_story]()
    var cycleImagesTitles = [String]()
    var cycleImagesURLString = [String]()
    var cycleScrollView = SDCycleScrollView()
    //
    var detailID = 0
    var url = NSURL()
    
    //UI size
    let width = UIScreen.mainScreen().bounds.width
    let height  = UIScreen.mainScreen().bounds.height
    
    var settingBtn = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
//        cellsSum.append(0)
        //data handle
        launchImageSet()
        url = NSURL(string: "http://news-at.zhihu.com/api/4/news/latest")!
        
        
        //navigation bar configure
        let loginBtn = UIBarButtonItem(title: "Login", style: .Plain, target: self, action: "loginBtnClicked")
        settingBtn = UIBarButtonItem(title: "Setting", style: .Plain, target: self, action: "settingBtnClicked")
        let barBtnGroup = [settingBtn,loginBtn]
        self.navigationItem.rightBarButtonItems = barBtnGroup
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0863, green: 0.4039, blue: 0.9725, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        //SDCycleScrollView adjust
        cycleScrollView.frame = CGRectMake(0, 0, width, 240)
        cycleScrollView.contentMode = .ScaleAspectFill
        cycleScrollView.clipsToBounds = true
        cycleScrollView.backgroundColor = UIColor.grayColor()
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView.delegate = self

        //tableView adjust
        tableView.backgroundColor = UIColor.grayColor()
        tableView.tableHeaderView = cycleScrollView
        tableView.rowHeight = 88
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        tableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3)
        tableView.indicatorStyle = UIScrollViewIndicatorStyle.White
        self.clearsSelectionOnViewWillAppear = false
        //SWRevealViewcontrolller adjust
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //self.navigationController?.hidesBarsOnSwipe = true
        
        //MJRefresh pull to refresh
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            NSLog("Refresh data ")
            self.cycleImagesTitles = [String]()
            self.cycleImagesURLString = [String]()
            self.cycleScrollView.imageURLStringsGroup = []
            self.cycleScrollView.titlesGroup = []
            self.allStoriesTitles = []
            self.allStoriesImages = []
            self.allStoriesID = []
            self.allDates = []
            self.forDetailIDS = []
            
            self.top_stories = [top_story]()
            self.dataFetch(self.url)

            
        })
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            if self.allDates.count != 0 {
                NSLog("request more data")

                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                let tmpdate = dateFormatter.dateFromString(self.allDates.last!)
//                let dateComponents = NSDateComponents()
//                dateComponents.month = 0
//                dateComponents.day = -1
//
//                let date = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: tmpdate!, options: NSCalendarOptions.init(rawValue: 0))
                let targetString = dateFormatter.stringFromDate(tmpdate!)
                let yesterURL = NSURL(string: "http://news.at.zhihu.com/api/4/news/before/\(targetString)")!
                
                self.dataFetch(yesterURL)
            }
        })
        
        self.dataFetch(url)
    
    }//viewDidLaod  ending
    
    //launch image set
    func launchImageSet(){
        let url = NSURL(string: "http://news-at.zhihu.com/api/4/start-image/1080*1776")
        
        netRequest(url!){ (json) -> Void in
        if let imageURL = json["img"].string{
            
            let imageData = NSData(contentsOfURL: NSURL(string: imageURL)!)
            let mainWindow = UIApplication.sharedApplication().keyWindow
            let imageView = UIImageView(frame: CGRectMake(0, 0, self.width, self.height))
            imageView.image = UIImage(data: imageData!)
            imageView.contentMode = .ScaleAspectFill
            mainWindow?.addSubview(imageView)
            
            let label = UILabel(frame: CGRectMake(0,self.height - 50,self.width,20))
            label.contentMode = .Right
            label.text = json["text"].stringValue
            label.textColor = UIColor.lightGrayColor()
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = .Right
            mainWindow?.addSubview(label)
            
            //animation start
            UIView.animateWithDuration(3, animations: {
                let rect = CGRectMake(-100, -100, self.width+200, self.height+200)
                imageView.frame = rect
                }, completion: { (completion) -> Void in
                    if completion {
                        UIView.animateWithDuration(1, animations: {
                            imageView.alpha = 0
                            label.alpha = 0
                            }, completion: { (complete) -> Void in
                                if complete{
                                    imageView.removeFromSuperview()
                                    label.removeFromSuperview()
                                }
                        })
                    }
            })//animation end
        }
        
        }
        
        //animation
//        UIView.animateWithDuration(3,animations:{
//            let height = UIScreen.mainScreen().bounds.size.height
//            let rect = CGRectMake(-100,-100,width+200,height+200)
//            img.frame = rect
//            },completion:{
//                (Bool completion) in
//                
//                if completion {
//                    UIView.animateWithDuration(1,animations:{
//                        img.alpha = 0
//                        lbl.alpha = 0
//                        },completion:{
//                            (Bool completion) in
//                            
//                            if completion {
//                                img.removeFromSuperview()
//                                lbl.removeFromSuperview()
//                            }
//                    })
//                }
//        })
        
    }
    

    //MARK:-- BarBtn func
    
    func loginBtnClicked(){
        
    }
    
    func settingBtnClicked(){
        //
//        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let popVC = storyboard.instantiateViewControllerWithIdentifier("popVC")
//        popVC.modalPresentationStyle = .Popover
//        presentViewController(popVC, animated: true, completion: nil)
//        let pController: UIPopoverPresentationController =
//           popVC.popoverPresentationController!
//        //pController.sourceRect = CGRectMake(200,200,200,200)
//        pController.permittedArrowDirections =
//            UIPopoverArrowDirection.Any//&& UIPopoverArrowDirection.Right
//        pController.barButtonItem = self.settingBtn
//        pController.delegate = self
        
    }
   

    //SDCycleViewDelegate
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int){
        let mainToDetailVC = detailViewController()
        let detailSegue = UIStoryboardSegue(identifier: "mainToDetail", source: self, destination: mainToDetailVC) { () -> Void in
            self.showViewController(mainToDetailVC, sender: nil)
            NSLog("performing...")
        }
        self.detailID = self.top_stories[index].id
    
        NSLog("detailID\(detailID)")
        mainToDetailVC.id = self.detailID
        for i in self.top_stories{
           mainToDetailVC.IDS.append(i.id)
        }
        //mainToDetailVC.IDS = self.forDetailIDS
        
        detailSegue.perform()
        //prepareForSegue(detailSegue, sender: nil)
        
    }

  

    // MARK: - Table view data source and delegate

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.allDates.count
        
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let titleLabel = UILabel(frame: CGRectMake(0,0,width*0.5,30))
        titleLabel.text = "HomePage"
        titleLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = titleLabel
        titleLabel.textAlignment = .Left
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        for i in 0...self.allDates.count{
            if section == 0 {
                return "Todays News"
            }
            if section == i{
                let tmpDate = dateFormatter.dateFromString(self.allDates[i])
                dateFormatter.dateFormat = "yyyy-MM-dd EEEE "
                let tmpString =  dateFormatter.stringFromDate(tmpDate!)
                //titleLabel.text = tmpString
                return tmpString
            }
        }
        return "HomePage"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        return self.allStoriesID[section].count
     
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: myTableViewCell! = tableView.dequeueReusableCellWithIdentifier("myTableViewCell") as? myTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "myTableViewCell", bundle: nil), forCellReuseIdentifier: "myTableViewCell")
            cell = tableView.dequeueReusableCellWithIdentifier("myTableViewCell") as? myTableViewCell
        }
        
        // Configure the cell...
        if (self.allDates.count != 0) {
            
            let row = indexPath.row
            let section = indexPath.section
            NSLog("\(indexPath.row) after the row is\(row)")
            cell.myLabel?.text = self.allStoriesTitles[section][row]
            cell.myLabel?.numberOfLines = 3
            let imageData = NSData(contentsOfURL: NSURL(string: self.allStoriesImages[section][row])!)
                cell.myImageView?.image = UIImage(data: imageData!)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mainToDetailVC = detailViewController()
        let detailSegue = UIStoryboardSegue(identifier: "mainToDetail", source: self, destination: mainToDetailVC) { () -> Void in
            self.showViewController(mainToDetailVC, sender: nil)
            NSLog("performing...")
        }
        self.detailID = self.allStoriesID[indexPath.section][indexPath.row]
        mainToDetailVC.id = self.detailID
        mainToDetailVC.IDS = self.forDetailIDS
        NSLog("detailID\(detailID)")
        detailSegue.perform()
        //prepareForSegue(detailSegue, sender: nil)

    }


    func dataFetch(urlString:NSURL){
        
        netRequest(urlString) { (json) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //date
               
                if let tmpDate = json["date"].string{
                    self.allDates.append(tmpDate)
                }
                //stories
                let storiesJsonArray = json["stories"]
                var tmpTitleArr = [String]()
                var tmpImagesArr = [String]()
                var tmpIDArr = [Int]()
                for index in 0...storiesJsonArray.count-1{
                    
                    
                    //handle title
                    if let tmpTitle = json["stories", index,"title"].string{
                        tmpTitleArr.append(tmpTitle)
                    }else{
                        tmpTitleArr.append("NO Title")
                    }
                    
                    //handle imagesURL
                    if let tmpImageString = json["stories",index,"images",0].string {
                        tmpImagesArr.append(tmpImageString)
                    }else{
                        tmpImagesArr.append("NO Image")
                    }
                    
                    //handel id
                    if let tmpID = json["stories",index,"id"].int{
                        tmpIDArr.append(tmpID)
                        self.forDetailIDS.append(tmpID)
                    }else{
                        tmpIDArr.append(0)
                        self.forDetailIDS.append(0)
                    }
                }
                self.allStoriesTitles.append(tmpTitleArr)
                self.allStoriesImages.append(tmpImagesArr)
                self.allStoriesID.append(tmpIDArr)
                
                //top_stories, notice past data no this
                let top_storiesJsonArray = json["top_stories"]
                if top_storiesJsonArray.count != 0 {
                    for index in 0...top_storiesJsonArray.count-1{
                        var top_Story = top_story()
                        top_Story.title = json["top_stories", index,"title"].stringValue
                        top_Story.images = json["top_stories",index,"image"].stringValue
                        top_Story.id = json["top_stories",index,"id"].int!
                        self.top_stories.append(top_Story)
                        let tmpString:String = top_Story.images
                        self.cycleImagesURLString.append(tmpString)
                        
                        let tmpTitles:String = top_Story.title
                        self.cycleImagesTitles.append(tmpTitles)
                        //NSLog("sthe count is \(self.top_stories.count)")
                    }
                }
                
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                
                //set the cycleView
                self.cycleScrollView.imageURLStringsGroup = self.cycleImagesURLString as [AnyObject]
                self.cycleScrollView.titlesGroup = self.cycleImagesTitles as [AnyObject]
                
                self.tableView.reloadData()
            })

        }
    }
    
    
    
    
    
    
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




    // MARK: - functioal func 
    
    



