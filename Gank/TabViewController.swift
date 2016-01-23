//
//  TabViewController.swift
//  Gank
//
//  Created by Findys on 15/12/13.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController){
        
        if self.selectedViewController == viewController{
        viewController.view.viewWithTag(1)?.alpha = 0
        
        UIView.animateWithDuration(0.5) { () -> Void in
            
            viewController.view.viewWithTag(1)?.alpha = 1
            
        }
        }
        
        
    }
}
