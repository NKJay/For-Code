//
//  ViewController.swift
//  Gank
//
//  Created by Geek on 15/11/27.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
    @IBOutlet var newsTableView: UITableView!
    var URL =  "http://gank.avosapps.com/api/day/"
    var category = NSArray()
    var topImage = UIImageView()
    let kImageHeight:Float = 400
    let kInWindowHeight:Float = 200
    var data = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        newsTableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib
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
//            print(resp)
            self.data = resp.objectForKey("results")! as! NSDictionary
            self.category = resp.objectForKey("category")! as! NSArray
            let fuli = self.data.objectForKey("福利") as! NSArray
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
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                print(error)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return category.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let lbl = UILabel(frame:CGRectMake(0,0,320,30))
        lbl.backgroundColor = UIColor.lightGrayColor()
        lbl.text = self.category[section-1] as? String
        lbl.textColor = UIColor.whiteColor()
        lbl.textAlignment = NSTextAlignment.Center
        lbl.font = UIFont.systemFontOfSize(14)
        return lbl
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = newsTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        print(indexPath.row)
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
    
    func scrollViewDidScroll(scrollView: UIScrollView)
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

}

