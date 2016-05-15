//
//  PictureViewController.swift
//  For Code
//
//  Created by 胡健 on 26/02/2016.
//  Copyright © 2016 GeekTeen. All rights reserved.
//

import UIKit

class PictureViewController: UICollectionViewController,WaterFallFlowLayoutDelegate,WaterFallFlowLayoutDatasource{
    
    var URL = "http://gank.io/api/data/福利/10/"
    var imgArray = NSMutableArray()
    var page = 2
    var cell_X:[CGFloat] = [0,0,0]
    var cell_Y:[CGFloat] = [2,2,2]
    var cellOrigin = NSMutableArray()

    let wt = WaterFallFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.edgesForExtendedLayout = UIRectEdge.None
//        将url转换成utf-8
        URL = URL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        requestImage()
        
        requestMoreImage()
        
        wt.initWithFrameRect(self.view.frame)
        
        wt.delegate = self
        wt.dataSource = self
        
        self.view.addSubview(wt)

    }
    
    func requestImage(){
        
        let manager = AFHTTPSessionManager();
        
        let firstRequest:String = URL + "1"
        
        manager.GET(firstRequest, parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            
            let results = resp?.objectForKey("results") as! NSArray
            
            let currentArray = NSMutableArray()
            
            for each in results{
                
                let imgUrl = NSURL(string: (each["url"]!)! as! String)
                
                let data = NSData(contentsOfURL: imgUrl!)
                
                let image = UIImage(data: data!)
                
                currentArray.addObject(image!)

            }
            
            self.imgArray = currentArray
            
            print(self.imgArray)
            
            self.wt.reloadData()
            
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
        }
    }
    
    func requestMoreImage(){
        
        let manager = AFHTTPSessionManager();
        
        let requestUrl = URL + String(page)
        
        manager.GET(requestUrl, parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            
            let results = resp?.objectForKey("results") as! NSArray
            
            for each in results{
                
                let imgUrl = NSURL(string: (each["url"]!)! as! String)
                
                let data = NSData(contentsOfURL: imgUrl!)
                
                let image = UIImage(data: data!)
                
                self.imgArray.addObject(image!)
                
            }
            self.wt.reloadData()
            
            self.page += 1
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
        }
    }
    
    func waterFallFlowLayout(didselectImageView indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
    func waterFallFlowLayout(numberOfItemsInSection section:Int)->Int{
        return imgArray.count
    }
    
    func waterFallFlowLayout(heightofItemAtIndexPath indexPath: NSIndexPath, itemWidth: CGFloat) -> CGFloat {
        
        let image = imgArray[indexPath.row]
        
        let newHeight = image.size.height/image.size.width * itemWidth
        
        return newHeight
    }
    
    func waterFallFlowLayout(viewAtIndexPath view:UIView,indexPath:NSIndexPath)->UIView {
        
        let imageView = imgArray[indexPath.row]
        
        view.addSubview(imageView as! UIView)
        
        return view
    }
    
//    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
//        return imgArray.count
//    }
//
//    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
//        
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectioncell", forIndexPath: indexPath)
//        
//        let cellImage = self.imgArray[indexPath.item]
//        
//        let imageView = UIImageView(image: cellImage as? UIImage)
//        
//        imageView.frame = cell.bounds
//        
//        if indexPath.row < cellOrigin.count{
//            let size = CGPointFromString(cellOrigin[indexPath.row] as! String)
//            
//            cell.frame.origin = CGPoint(x: size.x, y: size.y)
//        }else{
//        
//        let col = indexPath.row % 3
//        
//        cell.frame.origin = CGPoint(x: cell_X[col], y: cell_Y[col])
//        
//        cellOrigin.addObject(NSStringFromCGPoint(cell.frame.origin))
//        
//        cell_Y[col] = cell_Y[col] + cell.bounds.height + 5
//        }
//        
//        cell.contentView.addSubview(imageView)
//        
//        return cell
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//        let image = self.imgArray[indexPath.item]
//        
////        let size = self.imgSize(image.size.height, width: image.size.width)
//        
//        return CGSize(width: size.width, height: size.height)
//    }
    
}
