//
//  IOSViewController.swift
//  Gank
//
//  Created by Geek on 15/11/28.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit

class IAViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    let URL = "http://gank.avosapps.com/api/data/iOS/10/1"
    var dataSource = []
    @IBOutlet weak var newsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
    func loadData(){
        let afmanager = AFHTTPRequestOperationManager()
        afmanager.GET(URL, parameters: nil, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            let results = resp.objectForKey("results")! as! NSArray
            let currentNewsDataSource = NSMutableArray()
            for each in results{
                let item = NewsItem()
                item.author = each.objectForKey("who")! as! NSString
                item.title = each.objectForKey("desc")! as! NSString
                item.url = each.objectForKey("url")! as! NSString
                item.time = each.objectForKey("publishedAt") as! NSString
                currentNewsDataSource.addObject(item)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dataSource = currentNewsDataSource
                self.newsTableView.reloadData()
                
            })
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                print(error)
        }
    }
    
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
