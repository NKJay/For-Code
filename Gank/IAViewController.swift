//
//  IOSViewController.swift
//  Gank
//
//  Created by Geek on 15/11/28.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit
import CoreData

class IAViewController:UIViewController,UITableViewDataSource,UITableViewDelegate {
    var URL = String()
    var dataSource = NSMutableArray()
    var navigation = UINavigationController()
    var i = 2
    var newsTableView = UITableView()
    var entityName = String()
    
    //    初始化View
    func initMyView(myURL:String,myTableView:UITableView,myEntityName:String,navigationController:UINavigationController,selfView:UIView) {
        navigation = navigationController
        URL = myURL
        newsTableView = myTableView
        entityName = myEntityName
        
        newsTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.requestData()
        })
        
        newsTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.loadMoreData()
        })
        
        requestData()
        
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    //    加载数据
    func requestData(){
        
        let loadUrl = URL + "1"
        let afmanager = AFHTTPSessionManager()
        
        afmanager.GET(loadUrl, parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            
            let results = resp!.objectForKey("results")! as! NSArray
            self.loadData(results)
            
            userdefault.setObject(results, forKey: self.entityName)
            userdefault.synchronize()
            
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let _ = userdefault.objectForKey(self.entityName){
                        
                        let results = userdefault.objectForKey(self.entityName) as! NSArray
                        self.loadData(results)
                        
                        self.newsTableView.mj_header.endRefreshing()
                        
                        self.notice("请检查网络", type: NoticeType.error, autoClear: true)
                    }
                })
                
        }
        
    }
    
    func loadData(results:NSArray){
        
        let currentData = NSMutableArray()
        
        for each in results{
            let item = NewsItem()
            item.author = each.objectForKey("who")! as! String
            item.title = each.objectForKey("desc")! as! String
            item.url = each.objectForKey("url")! as! String
            
            currentData.addObject(item)
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.dataSource = currentData
            self.newsTableView.reloadData()
            self.newsTableView.mj_header.endRefreshing()
            
        })
    }
    
    func loadMoreData(){
        let loadUrl = URL + String(i++)
        let afmanager = AFHTTPSessionManager()
        afmanager.GET(loadUrl, parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            
            let results = resp!.objectForKey("results")! as! NSArray
            for each in results{
                
                let item = NewsItem()
                item.author = each.objectForKey("who")! as! String
                item.title = each.objectForKey("desc")! as! String
                item.url = each.objectForKey("url")! as! String
                
                self.dataSource.addObject(item)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.newsTableView.reloadData()
                self.newsTableView.mj_footer.endRefreshing()
                
            })
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                self.newsTableView.mj_footer.endRefreshing()
                self.notice("请检查网络", type: NoticeType.error, autoClear: true)
        }
        
    }
    
    
    //    Tableview的datasource和delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataSource.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let title = cell.viewWithTag(1) as! UILabel
        let author = cell.viewWithTag(2) as! UILabel
        
        let item = dataSource[indexPath.row] as! NewsItem
        
        title.text = item.title as String
        author.text = item.author as String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let item = dataSource[indexPath.row] as! NewsItem
        
        let webView = WebViewController()
        webView.url = item.url as String
        
        navigation.pushViewController(webView, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

