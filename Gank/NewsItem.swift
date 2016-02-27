//
//  IOSNewsItem.swift
//  Gank
//
//  Created by Geek on 15/11/28.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import Foundation

class NewsItem:NSObject,NSCoding {
    
    var title = String()
    var author = String()
    var url = String()
    
    override init() {
        super.init()
    }
    
    //解包数据
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.author = aDecoder.decodeObjectForKey("author") as! String
        self.url = aDecoder.decodeObjectForKey("url") as! String
    }
    
    //打包数据
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(author, forKey: "author")
        aCoder.encodeObject(url, forKey: "url")
    }
}