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
    var myWebView = WKWebView()
    var progressBar = UIProgressView()
    
    override func loadView() {
        super.loadView()
        let frame = CGRect(x: 0, y:0, width: WINDOW_WIDTH, height: WINDOW_HEIGHT)
        self.view.backgroundColor = UIColor.whiteColor()
        myWebView = WKWebView(frame: frame)
        myWebView.alpha = 0
        myWebView.navigationDelegate = self
        self.view.addSubview(myWebView)
        
        let openUrl = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "openUrl")
        openUrl.title = "打开"
        self.navigationItem.rightBarButtonItem = openUrl
        
        progressBar.frame = CGRect(origin: CGPoint(x: 0, y: 64), size: CGSize(width: WINDOW_WIDTH, height: 5))
        progressBar.progress = 0
        progressBar.backgroundColor = UIColor.whiteColor()
        progressBar.progressTintColor = UIColor(red: 250/255.0, green: 106/255.0, blue: 0, alpha: 1)
        self.view.addSubview(progressBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        myWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        myWebView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        UIView.animateWithDuration(0.3) { () -> Void in
            let frame = self.tabBarController?.tabBar.frame
            self.tabBarController?.tabBar.frame = CGRect(x: frame!.origin.x, y: frame!.origin.y + 50, width: frame!.width, height: frame!.height)
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        myWebView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressBar.setProgress(0.0, animated: false)
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        UIView.animateWithDuration(0.3) { () -> Void in
            let frame = self.tabBarController?.tabBar.frame
            self.myWebView.alpha = 1
            self.tabBarController?.tabBar.frame = CGRect(x: frame!.origin.x, y: frame!.origin.y - 50, width: frame!.width, height: frame!.height)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        myWebView.alpha = 0
        myWebView.removeFromSuperview()
    }
    
    
    //    添加KVO相应事件
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress"){
            if myWebView.estimatedProgress == 1{
                progressBar.hidden = true
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.myWebView.alpha = 1
                })
            }
            progressBar.setProgress(Float(myWebView.estimatedProgress), animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    用safari打开网页
    func openUrl(){
        let alert = UIAlertView()
        alert.message = "要用Safari打开网页吗？"
        alert.addButtonWithTitle("取消")
        alert.addButtonWithTitle("是的")
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
