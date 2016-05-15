//
//  LaunchScreen.swift
//  For Code
//
//  Created by Geetion on 16/1/4.
//  Copyright © 2016年 GeekTeen. All rights reserved.
//

import UIKit


class LaunchScreen:NSObject{
    
    static var title:UILabel? = {
        var title = UILabel()
        title.frame.size = CGSize(width: Util.WINDOW_WIDTH, height: 100)
        title.font = UIFont(name: "Verdana-BoldItalic", size: 40)
        title.text = "For Code"
        title.textAlignment = NSTextAlignment.Center
        title.center = CGPoint(x: Util.WINDOW_WIDTH/2, y: Util.WINDOW_HEIGHT/2-50)
        title.alpha = 0
        title.textColor = UIColor.whiteColor()
        return title
    }()
    
    static var smallTitle:UILabel? = {
        var title = UILabel()
        title.frame.size = CGSize(width: Util.WINDOW_WIDTH, height: 20)
        title.center = CGPoint(x: Util.WINDOW_WIDTH/2, y: Util.WINDOW_HEIGHT/2)
        title.textAlignment = NSTextAlignment.Center
        title.textColor = UIColor.lightGrayColor()
        title.font = UIFont.systemFontOfSize(15)
        title.text = "gank.io"
        title.alpha = 0
        return title
        
    }()
    
    //    启动图的显示和隐藏
    static var launchImage:UIImageView? = {
        var image = UIImageView()
        image = UIImageView(frame:CGRectMake(0, 0, Util.WINDOW_WIDTH, Util.WINDOW_HEIGHT))
        return image
    }()
    
    static let window = UIApplication.sharedApplication().keyWindow
    
    static func showLaunch(image:UIImage){
        
        self.launchImage!.image = image
        
        window!.addSubview(launchImage!)
        window!.addSubview(title!)
        window?.addSubview(smallTitle!)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            title!.alpha = 1
            smallTitle!.alpha = 1
            
        })
        
        UIView.animateWithDuration(2,animations:{
            self.launchImage!.frame = CGRectMake(-50,-50/9*16,
                Util.WINDOW_WIDTH+100,Util.WINDOW_HEIGHT+100/9*16)
            },completion:{
                (completion) in
                if completion {
                    UIView.animateWithDuration(1,animations:{
                        self.launchImage!.alpha = 0
                        title!.alpha = 0
                        smallTitle!.alpha = 0
                        },completion:{
                            (completion) in
                            
                            if completion {
                                self.launchImage!.removeFromSuperview()
                                title!.removeFromSuperview()
                                smallTitle!.removeFromSuperview()
                            }
                    })
                }
        })
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(LaunchScreen.hideLaunch), userInfo: nil, repeats: false)
    }
    
    static func hideLaunch(){
        title!.removeFromSuperview()
        smallTitle!.removeFromSuperview()
        launchImage!.removeFromSuperview()
    }
    
}
