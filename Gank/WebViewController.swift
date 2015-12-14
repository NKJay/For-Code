//
//  WebViewController.swift
//  Gank
//
//  Created by Findys on 15/12/9.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var url = String()
    var myWebView = WKWebView()
    var progressBar = UIProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let frame = CGRect(x: 0, y: 64, width: WINDOW_WIDTH, height: WINDOW_HEIGHT-64)
        myWebView = WKWebView(frame: frame)
        self.view.addSubview(myWebView)
        
        let openUrl = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "openUrl")
        openUrl.title = "打开"
        self.navigationItem.rightBarButtonItem = openUrl
        
        progressBar.frame = CGRect(origin: CGPoint(x: 0, y: 64), size: CGSize(width: WINDOW_WIDTH, height: 5))
        progressBar.progress = 0
        progressBar.backgroundColor = UIColor.lightGrayColor()
        progressBar.progressTintColor = UIColor.redColor()
        self.view.addSubview(progressBar)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        myWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        myWebView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        UIView.animateWithDuration(0.3) { () -> Void in
            let frame = self.tabBarController?.tabBar.frame
            self.tabBarController?.tabBar.frame = CGRect(x: frame!.origin.x, y: frame!.origin.y + 50, width: frame!.width, height: frame!.height)
        }
    }
    
    
    //    view将要消失时执行
    override func viewWillDisappear(animated: Bool) {
        myWebView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressBar.setProgress(0.0, animated: false)
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        UIView.animateWithDuration(0.3) { () -> Void in
            let frame = self.tabBarController?.tabBar.frame
            self.tabBarController?.tabBar.frame = CGRect(x: frame!.origin.x, y: frame!.origin.y - 50, width: frame!.width, height: frame!.height)
        }
    }
    
    
    //    添加KVO相应事件
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress"){
            progressBar.hidden = myWebView.estimatedProgress == 1
            progressBar.setProgress(Float(myWebView.estimatedProgress), animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openUrl(){
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
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
