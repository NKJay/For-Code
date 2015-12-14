//
//  ViewController.swift
//  Gank
//
//  Created by Geek on 15/11/27.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit
import CoreData

class TodayViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var newsTableView: UITableView!
    var URL =  "http://gank.avosapps.com/api/day/"
    var category = NSArray()
    var welfare = NSArray()
    var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var androidData = NSArray()
    var IOSData = NSArray()
    var recommend = NSArray()
    var videoData = NSArray()
    var expend = NSArray()
    var topImage = UIImageView()
    var data = NSDictionary()
    var i = Double()
    @IBOutlet weak var historyButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        showLaunch()
        loadData(getDate(false))
        newsTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData(self.getDate(false))
        })
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    获取数据
    func loadData(Date:String){
        let afmanager = AFHTTPRequestOperationManager()
        let getDataUrl = URL + Date
        afmanager.GET(getDataUrl, parameters: nil, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            self.data = resp.objectForKey("results")! as! NSDictionary
            self.category = resp.objectForKey("category")! as! NSArray
            if self.data.count == 0{
                self.loadData(self.getDate(true))
            }else{
                let currentIOS = self.getSingleData(self.IOSData, key: "iOS") as NSMutableArray
                let currentAndroid = self.getSingleData(self.androidData, key: "Android")
                let currentVideo = self.getSingleData(self.videoData, key: "休息视频")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.welfare = self.data.objectForKey("福利") as! NSArray
                    self.IOSData = currentIOS
                    self.androidData = currentAndroid
                    self.videoData = currentVideo
                    
                    //                self.androidData = self.data.objectForKey("Android") as! NSArray
                    //                self.video = self.data.objectForKey("休息视频") as! NSArray
                    //                self.recommend = self.data.objectForKey("瞎推荐") as! NSArray
                    //                self.expend = self.data.objectForKey("拓展资源") as! NSArray
                    self.newsTableView.reloadData()
                    self.newsTableView.mj_header.endRefreshing()
                })
            }
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                print(error)
        }
    }
    
//    获取单个类型数据
    func getSingleData(data:NSArray,key:String)->NSMutableArray{
        let resault = self.data.objectForKey(key) as! NSArray
        let currentData = NSMutableArray()
        for each in resault{
            let item = NewsItem()
            item.author = each.valueForKey("who")! as! String
            item.title = each.valueForKey("desc")! as! String
            item.url = each.valueForKey("url")! as! String
            currentData.addObject(item)
        }
        return currentData
    }
    
    //    缓存数据
    func cacheData(title:String,time:String,author:String,entityName:String,localData:NSArray){
        let row = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self.context)
        row.setValue(title, forKey: "title")
        row.setValue(time, forKey: "time")
        row.setValue(author, forKey: "author")
        try! context.save()
    }
    
    func clearCache(localData:NSArray){
        for each in localData{
            context.deleteObject(each as! NSManagedObject)
        }
    }
    
    
    //    判断今天是否有数据并获取日期
    func getDate(changDate:Bool)->String{
        let date = NSDate()
        let dataformator = NSDateFormatter()
        dataformator.dateFormat = "EEE"
        var day = dataformator.stringFromDate(date)
        if changDate{
            dataformator.dateFormat = "yyyy/MM/dd"
            let yesterday = date.dateByAddingTimeInterval(-60 * 60 * 24 * i) as NSDate
            day = dataformator.stringFromDate(yesterday)
            i++
        }else{
            dataformator.dateFormat = "yyyy/MM/dd"
            day = dataformator.stringFromDate(date)
        }
        print(day)
        return day
        
    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView)
//    {
//        updateOffsets()
//    }
//    
//    func updateOffsets() {
//        let yOffset   = self.newsTableView.contentOffset.y
//        let threshold = CGFloat(kImageHeight - kInWindowHeight)
//        
//        if Double(yOffset) > Double(-threshold) && Double(yOffset) < -64 {
//            self.topImage.frame = CGRect(origin: CGPoint(x: 0,y: -100+yOffset/2),size: CGSize(width: 320,height: 300-yOffset/2));
//        }
//        else if yOffset < -64 {
//            self.topImage.frame = CGRect(origin: CGPoint(x: 0,y: -100+yOffset/2),size: CGSize(width: 320,height: 300-yOffset/2));
//        }
//        else {
//            self.topImage.frame = CGRect(origin: CGPoint(x: 0,y: -100),size: CGSize(width: 320,height: 300));
//        }
//    }
    
    //    显示启动图
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
    
//    func imageTap(){
//        let newimage = UIImageView(image: topImage.image)
//        newimage.frame = CGRect(x: 0, y: 64, width: WINDOW_WIDTH, height: WINDOW_WIDTH)
//        newimage.contentMode = UIViewContentMode.ScaleAspectFill
//        newimage.alpha = 0
//        newimage.userInteractionEnabled = true
//        newimage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapHide"))
//        self.view.addSubview(newimage)
//        UIView.animateWithDuration(1) { () -> Void in
//            newimage.alpha = 1
//        }
//    }
    
    //    tableView的datasource和delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let lbl = UILabel(frame:CGRectMake(0,0,320,25))
        lbl.backgroundColor = UIColor(red: 245/255.0, green: 102/255.0, blue: 70/255.0, alpha: 0.7)
        switch section{
        case 1: lbl.text = "IOS";break
        case 2: lbl.text = "Android";break
        case 3: lbl.text = "休息视频";break
        case 4: lbl.text = "拓展资源";break
        default: break
        }
        lbl.textColor = UIColor.whiteColor()
        lbl.textAlignment = NSTextAlignment.Center
        lbl.font = UIFont.systemFontOfSize(14)
        return lbl
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 {
            return 0
        }
        return 25
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section{
        case 0: return welfare.count;
        case 1: return IOSData.count;
        case 2: return androidData.count;
        case 3: return videoData.count;
        case 4: return expend.count;
        case 5: return 2
        default: break
        }
        
        return 0
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 250
        }
        return 85
    }
    
    //    跳转webview并发送数据
    func sendToWeb(indexPath:NSIndexPath,dataSource:NSArray){
        let myStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let webView = myStoryboard.instantiateViewControllerWithIdentifier("webView") as! WebViewController
        let item = dataSource[indexPath.row] as! NewsItem
        webView.url = item.url as String
        
        self.navigationController!.pushViewController(webView, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section{
        case 1:sendToWeb(indexPath, dataSource: IOSData);break
        case 2:sendToWeb(indexPath, dataSource: androidData);break
        case 3:sendToWeb(indexPath, dataSource: videoData)
            break
        default:break
        }
        print(indexPath.section)
        print(indexPath.row)
        newsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
//    输出cell数据
    func putCellData(indexPath:Int,dataSource:NSArray)->UITableViewCell{
        let cell = newsTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let item = dataSource[indexPath] as! NewsItem
        let title = cell.viewWithTag(1) as! UILabel
        let author = cell.viewWithTag(2) as! UILabel
        title.text = item.title as String
        author.text = item.author as String
        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        switch indexPath.section{
        case 0:
        let cell = newsTableView.dequeueReusableCellWithIdentifier("ImageCell")! as UITableViewCell
        let imgURL = welfare.valueForKeyPath("url") as! NSArray
        topImage.contentMode = UIViewContentMode.ScaleAspectFill
         self.topImage.frame = CGRect(origin: CGPoint(x:0 , y: 0), size: CGSize(width: WINDOW_WIDTH, height: WINDOW_HEIGHT))
        topImage.sd_setImageWithURL(NSURL(string: imgURL[0] as! String), completed: { (img:UIImage!, error:NSError!, cache:SDImageCacheType, nsurl:NSURL!) -> Void in
            cell.addSubview(self.topImage)
        })
        return cell
        case 1:
            let cell = putCellData(indexPath.row, dataSource: IOSData);return cell
        case 2:
            let cell = putCellData(indexPath.row, dataSource: androidData);return cell
        case 3:
           let cell = putCellData(indexPath.row, dataSource: videoData);return cell
        default:break
        }
        return cell
    }
    
}

