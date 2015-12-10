//
//  IOSViewController.swift
//  Gank
//
//  Created by Geek on 15/11/28.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit

class IAViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var URL = String()
    var dataSource = NSMutableArray()
    var ifandroid = Bool()
    var i = 1
    @IBOutlet weak var newsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if ifandroid{
            URL = "http://gank.avosapps.com/api/data/android/10/1"
        }else{
         URL = "http://gank.avosapps.com/api/data/iOS/10/1"
        }
        loadData(URL)
        newsTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData(self.URL)
        })
        newsTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.loadMoreData()
        })
        // Do any additional setup after loading the view.
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
        let afmanager = AFHTTPRequestOperationManager()
        afmanager.GET(URL, parameters: nil, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            let results = resp.objectForKey("results")! as! NSArray
            for each in results{
                let item = NewsItem()
                item.author = each.objectForKey("who")! as! NSString
                item.title = each.objectForKey("desc")! as! NSString
                item.url = each.objectForKey("url")! as! NSString
                item.time = each.objectForKey("publishedAt") as! NSString
                self.dataSource.addObject(item)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.newsTableView.reloadData()
                self.newsTableView.mj_header.endRefreshing()
                self.newsTableView.mj_footer.endRefreshing()
                
            })
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                print(error)
        }
    }
    
    func loadMoreData(){
        URL = "http://gank.avosapps.com/api/data/iOS/10/"+String(i++)
        loadData(URL)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print(dataSource.count)
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
