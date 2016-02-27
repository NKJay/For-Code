//
//  PictureViewController.swift
//  For Code
//
//  Created by 胡健 on 26/02/2016.
//  Copyright © 2016 GeekTeen. All rights reserved.
//

import UIKit

class PictureViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var URL = "http://gank.io/api/data/福利/10/1"
    let imgArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.edgesForExtendedLayout = UIRectEdge.All
        
        URL = URL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        loadImage()

    }
    
    func loadImage(){
        
        let manager = AFHTTPSessionManager();
        manager.GET(URL, parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            
            let results = resp?.objectForKey("results") as! NSArray
            
            for each in results{
                
                let imgUrl = NSURL(string: (each["url"]!)! as! String)
                
                let data = NSData(contentsOfURL: imgUrl!)
                
                let image = UIImage(data: data!)
                
                self.imgArray.addObject(image!)

            }
            self.collectionView?.reloadData()
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imgArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectioncell", forIndexPath: indexPath)
        
        let cellImage = self.imgArray[indexPath.item]
        
        let imageView = UIImageView(image: cellImage as? UIImage)
        
        imageView.frame = cell.bounds
        
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let image = self.imgArray[indexPath.item]
        
        let height = self.imgHeight(image.size.height, width: image.size.width)
        
        return CGSize(width: 100, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let edgeinsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        return edgeinsets
    }
    
    func imgHeight(height:CGFloat,width:CGFloat)->CGFloat{
        return height/width*100
    }
}
