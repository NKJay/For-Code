//
//  IOSViewController.swift
//  Gank
//
//  Created by Geek on 15/11/28.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit
import CoreData

class AndroidViewController: UIViewController{
    var URL = "http://gank.avosapps.com/api/data/Android/10/"
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let AndroidView = IAViewController()
        AndroidView.initMyView(URL, myTableView: newsTableView, myEntityName: "AndroidNews", navigationController: self.navigationController!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
