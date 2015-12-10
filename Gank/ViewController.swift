//
//  ViewController.swift
//  Gank
//
//  Created by Geek on 15/11/27.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var URL =  "http://gank.avosapps.com/api/day/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view, typically from a nib
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    获取数据
    func loadData(){
        let afmanager = AFHTTPRequestOperationManager()
        let getDataUrl = URL + getDate(true)
        afmanager.GET(getDataUrl, parameters: nil, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            print(resp)
            let results = resp.objectForKey("results")! as! NSDictionary
//            print(results)
            for each in results{
                print(each)
            }
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
    
//    判断今天是否有数据并获取日期
    func getDate(ifdata:Bool)->String{
        let date = NSDate()
        let dataformator = NSDateFormatter()
        dataformator.dateFormat = "yyyy/MM/dd"
        if ifdata{
            let day = dataformator.stringFromDate(date)
            return day
        }
        else{
            let yesterday = date.dateByAddingTimeInterval(-60 * 60 * 24) as NSDate
            let day = dataformator.stringFromDate(yesterday)
            return day
        }
    }

}

