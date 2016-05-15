//
//  WebViewController.swift
//  Gank
//
//  Created by Findys on 15/12/9.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKNavigationDelegate {
    
    var url = String()
    
    lazy var myWebView:WKWebView? = {
        var wkWebView = WKWebView()
        let frame = CGRect(x: 0, y:0, width: Util.WINDOW_WIDTH, height: Util.WINDOW_HEIGHT+64)
        wkWebView = WKWebView(frame: frame)
        wkWebView.alpha = 0
        wkWebView.navigationDelegate = self
        return wkWebView
    }()
    
    lazy var progressBar:UIProgressView? = {
        var progress = UIProgressView()
        progress.frame = CGRect(origin: CGPoint(x: 0, y: 64),
                                   size: CGSize(width: Util.WINDOW_WIDTH, height: 5))
        progress.progress = 0
        progress.backgroundColor = UIColor.whiteColor()
        progress.progressTintColor = UIColor(red: 250/255.0, green: 106/255.0,
                                                blue: 0, alpha: 1)
        return progress
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
        

        self.view.addSubview(myWebView!)
        
        myWebView!.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        myWebView!.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        
        let openUrl = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action,
            target: self, action: #selector(WebViewController.openUrl))
        openUrl.title = "打开"
        self.navigationItem.rightBarButtonItem = openUrl
        

        self.view.addSubview(progressBar!)
    }
    
 
    override func viewWillAppear(animated: Bool) {
        
        UIView.animateWithDuration(0.3) { () -> Void in
            
            let frame = self.tabBarController?.tabBar.frame
            
            self.tabBarController?.tabBar.frame = CGRect(x: frame!.origin.x, y: frame!.origin.y + 50, width: frame!.width, height: frame!.height)
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        UIView.animateWithDuration(0.3) { () -> Void in
            
            let frame = self.tabBarController?.tabBar.frame
            
            self.tabBarController?.tabBar.frame = CGRect(x: frame!.origin.x, y: frame!.origin.y - 50, width: frame!.width, height: frame!.height)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        myWebView!.removeObserver(self, forKeyPath: "estimatedProgress")
        
        progressBar!.setProgress(0.0, animated: false)
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        myWebView!.alpha = 0
        myWebView!.removeFromSuperview()
    }
    
    
    //    添加KVO相应事件
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if (keyPath == "estimatedProgress"){
            
            if myWebView!.estimatedProgress == 1{
                
                progressBar!.hidden = true
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.myWebView!.alpha = 1
                })
            }
            
            progressBar!.setProgress(Float(myWebView!.estimatedProgress), animated: true)
        }
    }
    
    //    用safari打开网页
    func openUrl(){
        let alert = UIAlertView()
        alert.message = "要用Safari打开网页吗？"
        alert.addButtonWithTitle("取消")
        alert.addButtonWithTitle("是的")
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    
}
