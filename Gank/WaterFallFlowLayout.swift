//
//  WaterFallFlowLayout.swift
//  For Code
//
//  Created by 胡健 on 26/02/2016.
//  Copyright © 2016 GeekTeen. All rights reserved.
//

import UIKit

protocol WaterFallFlowLayoutDatasource{
    func waterFallFlowLayoutnumberOfItems()->Int
}

class WaterFallFlowLayout: UIScrollView{
    
    var WIDTH:CGFloat = 0
    
    var col:CGFloat = 3
    
    private var cell_X:[CGFloat] = [0,0,0]
    
    private var cell_Y:[CGFloat] = [2,2,2]
    
    private var cellOrigin = NSMutableArray()
    
    var dataSource = NSMutableArray()
    
    private var itemNumber = Int()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        getCell_X()
        
        WIDTH = self.frame.width
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func imgSize(height:CGFloat,width:CGFloat)->CGSize{
        
        let newWidth = (WIDTH - 20)/col
        let newHeight = height/width*newWidth
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func getCell_X(){
        
        cell_X[0] = 5
        cell_X[1] = Util.WINDOW_WIDTH/3 + 5
        cell_X[2] = Util.WINDOW_WIDTH/3*2 + 5
    }
    
    func reloadData(){
        layoutView()
    }
    
    func setDatasource(datasource:NSMutableArray){
        self.dataSource = datasource
        layoutView()
    }
    
    func layoutView(){
        
        for (var i = 0;i<dataSource.count;i++){

            let cellImage = self.dataSource[i]
            
            let imageView = UIImageView(image: cellImage as? UIImage)
            
            imageView.frame.size = sizeForItemAtIndexPath(i)
            
            if i < cellOrigin.count{
                let size = CGPointFromString(cellOrigin[i] as! String)
                
                imageView.frame.origin = CGPoint(x: size.x, y: size.y)
            }else{
                
                let col = i % 3
                
                imageView.frame.origin = CGPoint(x: cell_X[col], y: cell_Y[col])
                
                cellOrigin.addObject(NSStringFromCGPoint(imageView.frame.origin))
                
                cell_Y[col] = cell_Y[col] + imageView.frame.height + 5
            }
            
            self.addSubview(imageView)
        }
        
    }
    
    func sizeForItemAtIndexPath(indexPath: Int) -> CGSize {
        
        let image = dataSource[indexPath]
        
        let size = self.imgSize(image.size.height, width: image.size.width)
        
        return CGSize(width: size.width, height: size.height)
    }
}
