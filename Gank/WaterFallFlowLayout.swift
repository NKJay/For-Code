//
//  WaterFallFlowLayout.swift
//  For Code
//
//  Created by 胡健 on 26/02/2016.
//  Copyright © 2016 GeekTeen. All rights reserved.
//

import UIKit

@objc protocol WaterFallFlowLayoutDatasource{
    
    func waterFallFlowLayout(numberOfItemsInSection section:Int)->Int
    
    func waterFallFlowLayout(sizeofItemAtIndexPath indexPath:NSIndexPath)->CGSize
    
    optional func waterFallFlowLayout(numberOfColumnInSection section:Int)->Int
}
protocol WaterFallFlowLayoutDelegate{
    
    func waterFallFlowLayout(didselectImageView indexPath:NSIndexPath)
    
}

class WaterFallFlowLayout: UIView{
    
    var WIDTH:CGFloat?
    
    var col:Int = 3
    
    private var cell_X:[CGFloat] = [0,0,0]
    
    private var cell_Y:[CGFloat] = [2,2,2]
    
    private var cellOrigin = NSMutableArray()
    
    private var scrollView = UIScrollView()
    
    var dataSource:NSMutableArray?
    
    var delegate:WaterFallFlowLayoutDelegate?
    
    private var itemNumber = Int()
    
    func initWithFrameRect(frame:CGRect){
        
        self.frame = frame
        
        scrollView = UIScrollView(frame: frame)
        scrollView.scrollEnabled = true
        scrollView.bounces = true
        
        WIDTH = self.frame.width
        
        getCell_X()
        
        self.addSubview(scrollView)
    }

    func getCell_X(){
        
        cell_X[0] = 5
        cell_X[1] = WIDTH!/3 + 5
        cell_X[2] = WIDTH!/3*2 + 5
    }
    
    func reloadData(){
 
        layoutView()
    }
    
    func setDatasource(datasource:NSMutableArray){
        self.dataSource = datasource
    }
    
    func layoutView(){
        
        for (var i = 0;i<dataSource!.count;i++){

            let cellImage = self.dataSource![i]
            
            let imageView = UIImageView(image: cellImage as? UIImage)
            
            imageView.frame.size = sizeForItemAtIndexPath(i)
            
            if i < cellOrigin.count{
                let size = CGPointFromString(cellOrigin[i] as! String)
                
                imageView.frame.origin = CGPoint(x: size.x, y: size.y)
            }else{
                
                let currentCol = i % self.col
                
                imageView.frame.origin = CGPoint(x: cell_X[currentCol], y: cell_Y[currentCol])
                
                cellOrigin.addObject(NSStringFromCGPoint(imageView.frame.origin))
                
                cell_Y[currentCol] = cell_Y[currentCol] + imageView.frame.height + 5
            }
            
            imageView.tag = i
            
            let touch = UITapGestureRecognizer(target: self, action: "didSelectImageView:")
            
            imageView.userInteractionEnabled = true
            
            imageView.addGestureRecognizer(touch)
            
            self.scrollView.addSubview(imageView)
        }
        
        let maxHeight = getViewHeight()
        
        self.scrollView.contentSize = CGSize(width: WIDTH!, height: maxHeight)
        
    }
    
    func getViewHeight()->CGFloat{
        
        var maxHeight:CGFloat = 0
        
        for each in cell_Y{
            
            maxHeight = each > maxHeight ? each:maxHeight
        }
        
        return maxHeight
    }
    
    
    func sizeForItemAtIndexPath(indexPath: Int) -> CGSize {
        
        let image = dataSource![indexPath]
        
        let newWidth = (WIDTH! - 20)/CGFloat(col)
        
        let newHeight = image.size.height/image.size.width*newWidth
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func didSelectImageView(tap:UIGestureRecognizer){
        
        let indexPath = NSIndexPath(forRow: tap.view!.tag, inSection: 0)
        
        print(tap.view?.frame.origin)
        
        delegate?.waterFallFlowLayout(didselectImageView: indexPath)
    }
}
