//
//  AndroidViewController.swift
//  Gank
//
//  Created by Geek on 15/11/28.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit

class AndroidViewController: UIViewController {
    let URL = "http://gank.avosapps.com/api/data/Android/10/1"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                print(error)
        }
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
