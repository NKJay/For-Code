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
    
    func waterFallFlowLayout(heightofItemAtIndexPath indexPath:NSIndexPath,itemWidth:CGFloat)->CGFloat
    
    func waterFallFlowLayout(viewAtIndexPath view:UIView,indexPath:NSIndexPath)->UIView
    
    optional func waterFallFlowLayout(numberOfColumnInSection section:Int)->Int
    
    optional func waterFallFlowLayout(widthOfColumn section:Int)->CGFloat
    
    optional func waterFallFlowLayout()->NSSet
}

protocol WaterFallFlowLayoutDelegate{
    
    func waterFallFlowLayout(didselectImageView indexPath:NSIndexPath)
    
}

class WaterFallFlowLayout: UIView{
    
    private var WIDTH:CGFloat?
    
    private var col:Int = 3
    
    private var cell_X = [CGFloat]()
    
    private var cell_Y = [CGFloat]()
    
    private var cellOrigin = NSMutableArray()
    
    private var scrollView = UIScrollView()
    
    var dataSource:WaterFallFlowLayoutDatasource?
    
    var delegate:WaterFallFlowLayoutDelegate?
    
    private var itemNumber = Int()
    
    func initWithFrameRect(frame:CGRect){
        
        self.frame = frame
        
        scrollView = UIScrollView(frame: frame)
        scrollView.scrollEnabled = true
        scrollView.bounces = true
        
        WIDTH = self.frame.width
        
        getCellOrigin()
        
        self.addSubview(scrollView)
        
        if(dataSource != nil ){
            itemNumber = (dataSource?.waterFallFlowLayout(numberOfItemsInSection: 0))!
        }
    }
    
    func getCellOrigin(){
        
        for(var i = 0;i<col;i += 1 ){
            let newcell_X = self.WIDTH! / CGFloat(self.col) * CGFloat(i) + 5
            cell_X.append(newcell_X)
            
            cell_Y.append(5)
        }
        
    }
    
    func reloadData(){
        
        layoutView()
    }
    
    func layoutView(){
        
        for (var i = 0;i<itemNumber;i++){

            let view = UIView()
            
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            
            let imageView = dataSource?.waterFallFlowLayout(viewAtIndexPath: view, indexPath: indexPath)
            
            imageView!.frame.size = sizeForItemAtIndexPath(i)
            
            if i < cellOrigin.count{
                let size = CGPointFromString(cellOrigin[i] as! String)
                
                imageView!.frame.origin = CGPoint(x: size.x, y: size.y)
            }else{
                
                let currentCol = i % self.col
                
                imageView!.frame.origin = CGPoint(x: cell_X[currentCol], y: cell_Y[currentCol])
                
                cellOrigin.addObject(NSStringFromCGPoint(imageView!.frame.origin))
                
                cell_Y[currentCol] = cell_Y[currentCol] + imageView!.frame.height + 5
            }
            
            imageView!.tag = i
            
            let touch = UITapGestureRecognizer(target: self, action: "didSelectImageView:")
            
            imageView!.userInteractionEnabled = true
            
            imageView!.addGestureRecognizer(touch)
            
            self.scrollView.addSubview(imageView!)
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
        
        let newindexPath = NSIndexPath(forRow: indexPath, inSection: 0)
        
        let newWidth = (WIDTH! - 20)/CGFloat(col)
        
        let newHeight = dataSource?.waterFallFlowLayout(heightofItemAtIndexPath: newindexPath, itemWidth: newWidth)
        
        return CGSize(width: newWidth, height: newHeight!)
    }
    
    func didSelectImageView(tap:UIGestureRecognizer){
        
        let indexPath = NSIndexPath(forRow: tap.view!.tag, inSection: 0)
        
        delegate?.waterFallFlowLayout(didselectImageView: indexPath)
    }
}
