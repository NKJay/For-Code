//
//  IOSViewController.swift
//  Gank
//
//  Created by Geek on 15/11/28.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit
import CoreData

class IOSViewController: UIViewController {
    var URL = "http://gank.avosapps.com/api/data/iOS/10/"
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let IOSView = IAViewController()
        IOSView.initMyView(URL, myTableView: newsTableView, myEntityName: "IOSNews", navigationController: self.navigationController!,selfView: self.view.viewWithTag(1)!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
