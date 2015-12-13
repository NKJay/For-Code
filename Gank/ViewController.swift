//
//  ViewController.swift
//  Gank
//
//  Created by Geek on 15/11/27.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit

//let WINDOW_WIDTH = UIScreen.mainScreen().bounds.width
//let WINDOW_HEIGHT = UIScreen.mainScreen().bounds.height

class ViewController: UITableViewController {
    @IBOutlet var newsTableView: UITableView!
    var URL =  "http://gank.avosapps.com/api/day/"
    var category = NSArray()
    var welfare = NSArray()
    var androidData = NSArray()
    var IOSData = NSArray()
    var recommend = NSArray()
    var video = NSArray()
    var expend = NSArray()
    var topImage = UIImageView()
    let kImageHeight:Float = 400
    let kInWindowHeight:Float = 200
    var data = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        showLaunch()
        loadData()
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    获取数据
    func loadData(){
        let afmanager = AFHTTPRequestOperationManager()
        let getDataUrl = URL + getDate()
        afmanager.GET(getDataUrl, parameters: nil, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            self.data = resp.objectForKey("results")! as! NSDictionary
            self.category = resp.objectForKey("category")! as! NSArray
            //            print(fuli)
            //            for each in results{
            //                print(each)
            //            }
            //            let currentNewsDataSource = NSMutableArray()
            //            for each in results{
            //                let item = NewsItem()
            //                item.author = each.objectForKey("who")! as! NSString
            //                item.title = each.objectForKey("desc")! as! NSString
            //                item.url = each.objectForKey("url")! as! NSString
            //                item.time = each.objectForKey("publishedAt") as! NSString
            //                item.type = each.objectForKey("type") as! NSString
            //                print(item.title)
            //                currentNewsDataSource.addObject(item)
            //            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.category = resp.objectForKey("category")! as! NSArray
                self.welfare = self.data.objectForKey("福利") as! NSArray
                print(self.welfare)
                self.IOSData = self.data.objectForKey("iOS") as! NSArray
                self.androidData = self.data.objectForKey("Android") as! NSArray
                self.video = self.data.objectForKey("休息视频") as! NSArray
                self.recommend = self.data.objectForKey("瞎推荐") as! NSArray
                self.expend = self.data.objectForKey("拓展资源") as! NSArray
                self.newsTableView.reloadData()
            })
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                print(error)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 6
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let lbl = UILabel(frame:CGRectMake(0,0,320,30))
        lbl.backgroundColor = UIColor.lightGrayColor()
        switch section{
        case 1: lbl.text = "IOS";break
        case 2: lbl.text = "Android";break
        case 3: lbl.text = "休息视频";break
        case 4: lbl.text = "拓展资源";break
        case 5: lbl.text = "其它资源";break
        default: break
        }
        lbl.textColor = UIColor.whiteColor()
        lbl.textAlignment = NSTextAlignment.Center
        lbl.font = UIFont.systemFontOfSize(14)
        return lbl
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section{
        case 0: return welfare.count;
        case 1: return IOSData.count;
        case 2: return androidData.count;
        case 3: return video.count;
        case 4: return expend.count;
        case 5: return 2
        default: break
        }

        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        newsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        let cell = newsTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        var cell = UITableViewCell()
        if indexPath.section == 0{
            let imgURL = welfare.valueForKeyPath("url") as! NSArray
            topImage.sd_setImageWithURL(NSURL(string: imgURL[0] as! String), completed: { (img:UIImage!, error:NSError!, cache:SDImageCacheType, nsurl:NSURL!) -> Void in
                self.topImage.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: WINDOW_WIDTH, height: img.size.width/WINDOW_WIDTH*img.size.height))
                cell.addSubview(self.topImage)
            })
        }
        return cell
    }
    
    //    判断今天是否有数据并获取日期
    func getDate()->String{
        let date = NSDate()
        let dataformator = NSDateFormatter()
        dataformator.dateFormat = "EEE"
        var day = dataformator.stringFromDate(date)
        if day == "Sat"{
            dataformator.dateFormat = "yyyy/MM/dd"
            let yesterday = date.dateByAddingTimeInterval(-60 * 60 * 24) as NSDate
            day = dataformator.stringFromDate(yesterday)
        }
        else if day == "Sun"{
            dataformator.dateFormat = "yyyy/MM/dd"
            let yesterday = date.dateByAddingTimeInterval(-60 * 60 * 48) as NSDate
            day = dataformator.stringFromDate(yesterday)
        }else{
            dataformator.dateFormat = "yyyy/MM/dd"
            day = dataformator.stringFromDate(date)
        }
        return day
        
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView)
    {
        updateOffsets()
    }
    
    func updateOffsets() {
        let yOffset   = self.newsTableView.contentOffset.y
        let threshold = CGFloat(kImageHeight - kInWindowHeight)
        
        if Double(yOffset) > Double(-threshold) && Double(yOffset) < -64 {
            self.topImage.frame = CGRect(origin: CGPoint(x: 0,y: -100+yOffset/2),size: CGSize(width: 320,height: 300-yOffset/2));
        }
        else if yOffset < -64 {
            self.topImage.frame = CGRect(origin: CGPoint(x: 0,y: -100+yOffset/2),size: CGSize(width: 320,height: 300-yOffset/2));
        }
        else {
            self.topImage.frame = CGRect(origin: CGPoint(x: 0,y: -100),size: CGSize(width: 320,height: 300));
        }
    }
    
    func showLaunch(){
        let img = UIImageView(frame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT))
        let lbl = UILabel(frame:CGRectMake(WINDOW_WIDTH/2-50,WINDOW_HEIGHT/2-50,WINDOW_WIDTH,20))
        lbl.text = "干 货 集 中 营"
        lbl.font = UIFont(name: "System", size: 100)
        lbl.textAlignment = NSTextAlignment.Left
        img.image = UIImage(named: "LaunchImg")
        lbl.textColor = UIColor.whiteColor()
        let window = UIApplication.sharedApplication().keyWindow
        window!.addSubview(img)
        window!.addSubview(lbl)
        
        UIView.animateWithDuration(3,animations:{
            let rect = CGRectMake(-50,-50/9*16,WINDOW_WIDTH+100,WINDOW_HEIGHT+100/9*16)
            img.frame = rect
            },completion:{
                (Bool completion) in
                
                if completion {
                    UIView.animateWithDuration(1,animations:{
                        img.alpha = 0
                        lbl.alpha = 0
                        },completion:{
                            (Bool completion) in
                            
                            if completion {
                                img.removeFromSuperview()
                                lbl.removeFromSuperview()
                            }
                    })
                }
        })
    }

    
}

