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
    var key = ["福利","iOS","Android","休息视频","拓展资源","App","瞎推荐"]
    var todayCategory = NSMutableArray()
    let datePickervc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DatePicker") as! DatePickerViewController
    var topImage = UIImageView()
    let newimage = UIImageView()
    var data = NSDictionary()
    var dataSource = NSMutableArray()
    var i = Double(1)
    var imgBack = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLaunch()
        loadData(getDate(false))
        
        topImage.userInteractionEnabled = true
        topImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageTap"))
        
        newsTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData(self.getDate(false))
        })
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "hideLaunch", userInfo: nil, repeats: false)
        newsTableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        datePickervc.changeDate = {
            (date:String)->Void in
            self.todayCategory = []
            self.loadData(date)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func historySend(sender: AnyObject) {
        self.navigationController?.pushViewController(datePickervc, animated: true)
    }
    
    //    获取数据
    func loadData(Date:String){
        let afmanager = AFHTTPSessionManager()
        let getDataUrl = URL + Date
        afmanager.GET(getDataUrl, parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            self.data = resp!.objectForKey("results")! as! NSDictionary
            self.loadData()
            userdefault.setObject(self.data, forKey: "TodayData")
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                if let _ = userdefault.objectForKey("TodayData"){
                    self.data = userdefault.objectForKey("TodayData") as! NSDictionary
                    self.loadData()
                }
                self.notice("请检查网络", type: NoticeType.error, autoClear: true)
        }
    }
    
    func loadData(){
        let currentData = NSMutableArray()
        if self.data.count == 0{
            self.loadData(self.getDate(true))
        }else{
            self.i = 1
            for each in self.key{
                let current = self.getSingleData(each)
                if current.count != 0{
                    currentData.addObject(current)
                    self.todayCategory.addObject(each)
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                userdefault.setObject(self.todayCategory, forKey: "category")
                self.dataSource = currentData
                self.newsTableView.dataSource = self
                self.newsTableView.reloadData()
                self.newsTableView.mj_header.endRefreshing()
            })
        }
    }
    
    
    //    获取单个类型数据
    func getSingleData(key:String)->NSMutableArray{
        let currentData = NSMutableArray()
        if let _ = self.data.objectForKey(key){
            let resault = self.data.objectForKey(key) as! NSArray
            for each in resault{
                let item = NewsItem()
                item.author = each.valueForKey("who")! as! String
                item.title = each.valueForKey("desc")! as! String
                item.url = each.valueForKey("url")! as! String
                currentData.addObject(item)
            }
        }
        return currentData
    }
    
    
    //    判断今天是否有数据并获取日期
    func getDate(changDate:Bool)->String{
        let dataformator = NSDateFormatter()
        dataformator.dateFormat = "EEE"
        var day = dataformator.stringFromDate(Date)
        if changDate{
            dataformator.dateFormat = "yyyy/MM/dd"
            let yesterday = Date.dateByAddingTimeInterval(-60 * 60 * 24 * i) as NSDate
            day = dataformator.stringFromDate(yesterday)
            i++
        }else{
            dataformator.dateFormat = "yyyy/MM/dd"
            day = dataformator.stringFromDate(Date)
        }
        return day
    }
    
    
    //    显示启动图
    var txt = UILabel()
    var img = UIImageView()
    var lbl = UILabel()
    func showLaunch(){
        img = UIImageView(frame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT))
        lbl = UILabel(frame:CGRectMake(WINDOW_WIDTH/2-50,WINDOW_HEIGHT/2-50,WINDOW_WIDTH,100))
        lbl.font = UIFont(name: "Verdana-BoldItalic", size: 40)
        lbl.text = "For Code"
        lbl.textAlignment = NSTextAlignment.Center
        lbl.center = CGPoint(x: WINDOW_WIDTH/2, y: WINDOW_HEIGHT/2-50)
        img.image = UIImage(named: "IMG_0123")
        lbl.textColor = UIColor.whiteColor()
        txt = UILabel(frame:CGRectMake(WINDOW_WIDTH/2-50,WINDOW_HEIGHT/2,WINDOW_WIDTH,20))
        txt.center = CGPoint(x: WINDOW_WIDTH/2, y: WINDOW_HEIGHT/2)
        txt.textAlignment = NSTextAlignment.Center
        txt.textColor = UIColor.lightGrayColor()
        txt.font = UIFont.systemFontOfSize(15)
        txt.text = "gank.io"
        txt.alpha = 0
        lbl.alpha = 0
        
        let window = UIApplication.sharedApplication().keyWindow
        window!.addSubview(img)
        window!.addSubview(lbl)
        window?.addSubview(txt)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.txt.alpha = 1
            self.lbl.alpha = 1
        })
        
        UIView.animateWithDuration(2,animations:{
            let rect = CGRectMake(-50,-50/9*16,WINDOW_WIDTH+100,WINDOW_HEIGHT+100/9*16)
            self.img.frame = rect
            },completion:{
                (Bool completion) in
                if completion {
                    UIView.animateWithDuration(1,animations:{
                        self.img.alpha = 0
                        self.lbl.alpha = 0
                        self.txt.alpha = 0
                        },completion:{
                            (Bool completion) in
                            
                            if completion {
                                self.img.removeFromSuperview()
                                self.lbl.removeFromSuperview()
                                self.txt.removeFromSuperview()
                            }
                    })
                }
        })
    }
    
    func hideLaunch(){
        txt.removeFromSuperview()
        lbl.removeFromSuperview()
        img.removeFromSuperview()
    }
    
    //    图片点击放大
    func imageTap(){
        self.imgBack = UIView(frame: self.view.frame)
        newimage.image = topImage.image
        newimage.frame = CGRect(x: 0, y: 0, width: WINDOW_WIDTH, height: WINDOW_HEIGHT)
        newimage.contentMode = UIViewContentMode.ScaleAspectFit
        newimage.alpha = 0
        newimage.userInteractionEnabled = true
        newimage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapHide"))
        imgBack.alpha = 0
        imgBack.backgroundColor = UIColor.whiteColor()
        self.imgBack.addSubview(newimage)
        self.view.addSubview(imgBack)
        UIView.animateWithDuration(1) { () -> Void in
            self.newimage.alpha = 1
            self.imgBack.alpha = 1
        }
    }
    
    //    图片点击隐藏
    func tapHide(){
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.newimage.alpha = 0
            self.imgBack.alpha = 0
            }) { (Bool) -> Void in
                self.newimage.removeFromSuperview()
                self.imgBack.removeFromSuperview()
        }
    }
    
    //    跳转webview并发送数据
    func sendToWeb(indexPath:NSIndexPath,dataSource:NSArray){
        let webView = WebViewController()
        let item = dataSource[indexPath.row] as! NewsItem
        webView.url = item.url as String
        self.navigationController!.pushViewController(webView, animated: true)
    }
    
    //    tableView的datasource和delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let lbl = UILabel(frame:CGRectMake(0,0,320,25))
        lbl.backgroundColor = UIColor(red: 245/255.0, green: 102/255.0, blue: 70/255.0, alpha: 0.7)
        if section == 0{
            lbl.text = ""
        }else{
            lbl.text = todayCategory[section] as? String
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
        return dataSource[section].count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 250
        }
        return 85
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        sendToWeb(indexPath, dataSource: dataSource[indexPath.section] as! NSArray)
        newsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = newsTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell?
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        let sectionData = dataSource[indexPath.section]
        let item = sectionData[indexPath.row] as! NewsItem
        if indexPath.section == 0{
            let cell = newsTableView.dequeueReusableCellWithIdentifier("ImageCell")! as UITableViewCell?
            let imgURL = item.url as String
            topImage.contentMode = UIViewContentMode.ScaleAspectFill
            topImage.sd_setImageWithURL(NSURL(string: imgURL), completed: { (img:UIImage!, error:NSError!, cache:SDImageCacheType, nsurl:NSURL!) -> Void in
                self.topImage.frame = CGRect(origin: CGPoint(x:0 , y: 0), size: CGSize(width: WINDOW_WIDTH, height:250))
                cell!.addSubview(self.topImage)
            })
            return cell!
        }else{
            let title = cell!.viewWithTag(1) as! UILabel
            let author = cell!.viewWithTag(2) as! UILabel
            title.text = item.title as String
            author.text = item.author as String
        }
        return cell!
    }
    
}

