//
//  IOSViewController.swift
//  Gank
//
//  Created by Geek on 15/11/28.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit
import CoreData

class IAViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var URL = String()
    var dataSource = NSMutableArray()
    var ifandroid = Bool()
    var localData = NSArray()
    var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var i = 2
    @IBOutlet weak var newsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if ifandroid{
            URL = "http://gank.avosapps.com/api/data/android/10/"
        }else{
            URL = "http://gank.avosapps.com/api/data/iOS/10/"
        }
        loadData(URL)
        newsTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData(self.URL)
        })
        newsTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.loadMoreData()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //        let changHeight = newsTableView.frame.height-30
        //        let width = newsTableView.frame.width
        //        UIView.beginAnimations(nil, context: nil)
        //        UIView.setAnimationDuration(2.0)
        //        newsTableView.frame = CGRect(x: 200, y: 100, width: 100, height: 300)
        //        UIView.commitAnimations()
        //
        //        print("asd")
    }
    
    
    
    //    首次加载数据
    func loadData(URL:String){
        let loadUrl = URL + "1"
        let afmanager = AFHTTPRequestOperationManager()
        afmanager.GET(loadUrl, parameters: nil, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            let results = resp.objectForKey("results")! as! NSArray
            for each in results{
                let item = NewsItem()
                let row = NSEntityDescription.insertNewObjectForEntityForName("IOSNews", inManagedObjectContext: self.context)
                item.author = each.objectForKey("who")! as! String
                item.title = each.objectForKey("desc")! as! String
                item.url = each.objectForKey("url")! as! String
                item.time = each.objectForKey("publishedAt") as! String
                
                if self.dataSource.count < 10{
                    row.setValue(item.title, forKey: "title")
                    row.setValue(item.time, forKey: "time")
                    row.setValue(item.author, forKey: "author")
                }
                
                try! self.context.save()
                self.dataSource.addObject(item)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.newsTableView.reloadData()
                self.newsTableView.mj_header.endRefreshing()
                self.newsTableView.mj_footer.endRefreshing()
                
            })
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                let f = NSFetchRequest(entityName: "IOSNews")
                self.localData = try! self.context.executeFetchRequest(f)
                for i in 0...9{
                    let item = NewsItem()
                    item.author = self.localData[i].valueForKey("author")! as! String
                    item.time = self.localData[i].valueForKey("time")! as! String
                    item.title = self.localData[i].valueForKey("title")! as! String
                    self.dataSource.addObject(item)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.newsTableView.reloadData()
                    self.newsTableView.mj_header.endRefreshing()
                })
        }
    }
    
    //    加载更多数据
    func loadMoreData(){
        URL = "http://gank.avosapps.com/api/data/iOS/10/"+String(i++)
        let afmanager = AFHTTPRequestOperationManager()
        afmanager.GET(URL, parameters: nil, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            let results = resp.objectForKey("results")! as! NSArray
            for each in results{
                let item = NewsItem()
                let row = NSEntityDescription.insertNewObjectForEntityForName("IOSNews", inManagedObjectContext: self.context)
                item.author = each.objectForKey("who")! as! String
                item.title = each.objectForKey("desc")! as! String
                item.url = each.objectForKey("url")! as! String
                item.time = each.objectForKey("publishedAt") as! String
                
                if self.dataSource.count < 10{
                    row.setValue(item.title, forKey: "title")
                    row.setValue(item.time, forKey: "time")
                    row.setValue(item.author, forKey: "author")
                }
                
                try! self.context.save()
                self.dataSource.addObject(item)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.newsTableView.reloadData()
                self.newsTableView.mj_header.endRefreshing()
                self.newsTableView.mj_footer.endRefreshing()
                
            })
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                self.newsTableView.mj_footer.endRefreshing()
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataSource.count
        
    }
    
    //    加载每个cell的数据
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let title = cell.viewWithTag(1) as! UILabel
        let author = cell.viewWithTag(2) as! UILabel
        
        let item = dataSource[indexPath.row] as! NewsItem
        
        title.text = item.title as String
        author.text = item.author as String
        return cell
    }
    
    //    每个Cell的点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let myStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let webView = myStoryboard.instantiateViewControllerWithIdentifier("webView") as! WebViewController
        let item = dataSource[indexPath.row] as! NewsItem
        webView.url = item.url as String
        
        self.navigationController?.pushViewController(webView, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
