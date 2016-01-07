//
//  ViewController.swift
//  Gank
//
//  Created by Geek on 15/11/27.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var newsTableView: UITableView!
    
    var URL =  "http://gank.avosapps.com/api/day/"
    
    var key = ["福利","iOS","Android","休息视频","拓展资源","App","瞎推荐"]
    
    var todayCategory = NSMutableArray()
    
    let datePickerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DatePicker") as! DatePickerViewController
    
    var topImage = UIImageView()
    
    let newimage = UIImageView()
    
    var data = NSDictionary()
    
    var dataSource = NSMutableArray()
    
    var i = Double(1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showLaunch(UIImage(named: "IMG_0123")!)
        
        requestData(getDate(false))
        
        topImage.userInteractionEnabled = true
        topImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageTap"))
        
        newsTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.requestData(self.getDate(false))
        })
        
        newsTableView.delegate = self
        
        newsTableView.tag = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        
        datePickerViewController.changeDate = {
            (date:String)->Void in
            
            self.todayCategory = []
            
            self.requestData(date)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func historySend(sender: AnyObject) {
        
        self.navigationController?.pushViewController(datePickerViewController, animated: true)
        
    }
    
    func requestData(Date:String){
        
        let afmanager = AFHTTPSessionManager()
        
        let getDataUrl = URL + Date
        
        afmanager.GET(getDataUrl, parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            
            self.data = resp!.objectForKey("results")! as! NSDictionary
            self.loadData()
            
            userdefault.setObject(self.data, forKey: "TodayData")
            userdefault.synchronize()
            
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
                if userdefault.objectForKey("TodayData") != nil{
                    self.data = userdefault.objectForKey("TodayData") as! NSDictionary
                    self.loadData()
                }
                
                self.notice("请检查网络", type: NoticeType.error, autoClear: true)
        }
    }
    
    func loadData(){
        
        let currentData = NSMutableArray()
        
//        如果今天没数据则获取前一天的数据
        if self.data.count == 0{
            self.requestData(self.getDate(true))
        }else{
            
            self.i = 1
            
            for each in self.key{
                
                let current = self.setSingleData(each)
                
                if current.count != 0{
                    
                    currentData.addObject(current)
                    
                    self.todayCategory.addObject(each)
                    
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                userdefault.setObject(self.todayCategory, forKey: "category")
                userdefault.synchronize()
                
                self.dataSource = currentData
                self.newsTableView.dataSource = self
                self.newsTableView.reloadData()
                self.newsTableView.mj_header.endRefreshing()
            })
        }
    }
    
    
    //    设置单个类型数据
    func setSingleData(key:String)->NSMutableArray{
        
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
    
    
    
    //    top图片的点击放大和隐藏
    func imageTap(){
        
        newimage.image = topImage.image
        newimage.frame = CGRect(x: 0, y: 0, width: WINDOW_WIDTH, height: WINDOW_HEIGHT)
        newimage.contentMode = UIViewContentMode.ScaleAspectFit
        newimage.alpha = 0
        newimage.userInteractionEnabled = true
        newimage.backgroundColor = UIColor.whiteColor()
        newimage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapHide"))
        self.view.addSubview(newimage)
        
        UIView.animateWithDuration(1) { () -> Void in
            self.newimage.alpha = 1
        }
    }
    
    func tapHide(){
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            
            self.newimage.alpha = 0
            
            }) { (Bool) -> Void in
                
                self.newimage.removeFromSuperview()
                
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
        let headerTitle = UILabel(frame:CGRectMake(0,0,320,25))
        headerTitle.backgroundColor = UIColor(red: 245/255.0, green: 102/255.0, blue: 70/255.0, alpha: 0.7)
        
        if section == 0{
            
            headerTitle.text = ""
            
        }else{
            
            headerTitle.text = todayCategory[section] as? String
            
        }
        
        headerTitle.textColor = UIColor.whiteColor()
        headerTitle.textAlignment = NSTextAlignment.Center
        headerTitle.font = UIFont.systemFontOfSize(14)
        
        return headerTitle
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
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell?
        
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        let sectionData = dataSource[indexPath.section]
        
        let item = sectionData[indexPath.row] as! NewsItem
        
        if indexPath.section == 0{
            
            cell = tableView.dequeueReusableCellWithIdentifier("ImageCell")! as UITableViewCell?
            
            let imgURL = item.url as String
            
            topImage.contentMode = UIViewContentMode.ScaleAspectFill
            topImage.sd_setImageWithURL(NSURL(string: imgURL), completed: { (img:UIImage!, error:NSError!, cache:SDImageCacheType, nsurl:NSURL!) -> Void in
                self.topImage.frame = CGRect(origin: CGPoint(x:0 , y: 0), size: CGSize(width: WINDOW_WIDTH, height:250))
                
                cell!.addSubview(self.topImage)
            })
        }else{
            
            let title = cell!.viewWithTag(1) as! UILabel
            let author = cell!.viewWithTag(2) as! UILabel
            
            title.text = item.title as String
            author.text = item.author as String
        }
        return cell!
    }
    
}

