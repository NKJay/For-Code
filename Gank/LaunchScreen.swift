//
//  LaunchScreen.swift
//  For Code
//
//  Created by Geetion on 16/1/4.
//  Copyright © 2016年 GeekTeen. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func showLaunch(image:UIImage){
        
        LaunchScreen.showLaunch(image)
        
    }
    
    class LaunchScreen: NSObject {
        //    启动图的显示和隐藏
        static var launchTitle = UILabel()
        static var launchImage = UIImageView()
        static var launchSmallTitle = UILabel()
        static let window = UIApplication.sharedApplication().keyWindow
        
        static func showLaunch(image:UIImage){
            
            launchImage = UIImageView(frame:CGRectMake(0, 0, Util.WINDOW_WIDTH, Util.WINDOW_HEIGHT))
            launchImage.image = image
            
            launchTitle.frame.size = CGSize(width: Util.WINDOW_WIDTH, height: 100)
            launchTitle.font = UIFont(name: "Verdana-BoldItalic", size: 40)
            launchTitle.text = "For Code"
            launchTitle.textAlignment = NSTextAlignment.Center
            launchTitle.center = CGPoint(x: Util.WINDOW_WIDTH/2, y: Util.WINDOW_HEIGHT/2-50)
            launchTitle.alpha = 0
            launchTitle.textColor = UIColor.whiteColor()
            
            launchSmallTitle.frame.size = CGSize(width: Util.WINDOW_WIDTH, height: 20)
            launchSmallTitle.center = CGPoint(x: Util.WINDOW_WIDTH/2, y: Util.WINDOW_HEIGHT/2)
            launchSmallTitle.textAlignment = NSTextAlignment.Center
            launchSmallTitle.textColor = UIColor.lightGrayColor()
            launchSmallTitle.font = UIFont.systemFontOfSize(15)
            launchSmallTitle.text = "gank.io"
            launchSmallTitle.alpha = 0
            
            window!.addSubview(launchImage)
            window!.addSubview(launchTitle)
            window?.addSubview(launchSmallTitle)
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                self.launchTitle.alpha = 1
                self.launchSmallTitle.alpha = 1
                
            })
            
            UIView.animateWithDuration(2,animations:{
                self.launchImage.frame = CGRectMake(-50,-50/9*16,
                    Util.WINDOW_WIDTH+100,Util.WINDOW_HEIGHT+100/9*16)
                },completion:{
                    (Bool completion) in
                    if completion {
                        UIView.animateWithDuration(1,animations:{
                            self.launchImage.alpha = 0
                            self.launchTitle.alpha = 0
                            self.launchSmallTitle.alpha = 0
                            },completion:{
                                (Bool completion) in
                                
                                if completion {
                                    self.launchImage.removeFromSuperview()
                                    self.launchTitle.removeFromSuperview()
                                    self.launchSmallTitle.removeFromSuperview()
                                }
                        })
                    }
            })
            NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "hideLaunch", userInfo: nil, repeats: false)
        }
        
        static func hideLaunch(){
            launchTitle.removeFromSuperview()
            launchSmallTitle.removeFromSuperview()
            launchImage.removeFromSuperview()
        }

    }
}
