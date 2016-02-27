//
//  WaterFallFlowLayout.swift
//  For Code
//
//  Created by 胡健 on 26/02/2016.
//  Copyright © 2016 GeekTeen. All rights reserved.
//

import UIKit

class WaterFallFlowLayout: UICollectionViewFlowLayout{
    
    let colCount = 3
    var cellCount = Int()
    let colArray = NSMutableArray()
    let attributeDict = NSMutableDictionary()
    var delegate:UICollectionViewDelegateFlowLayout?
    
    override func prepareLayout() {
        super.prepareLayout()
        
        delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout
        
        self.cellCount = (self.collectionView?.numberOfItemsInSection(0))!
        if cellCount == 0{
            return;
        }
        
        let top = 0
        
        for(var i = 0;i < colCount; i++ ){
            self.colArray.addObject(top)
        }
        
        for(var i = 0;i < cellCount; i++ ){
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            self.layoutItemAtIndexPath(indexPath)
        }
    }
    
    func layoutItemAtIndexPath(indexPath:NSIndexPath){
        
        let itemSize  = delegate!.collectionView!(self.collectionView!, layout: self, sizeForItemAtIndexPath: indexPath) as CGSize
        
        let edgeInsets = (self.delegate?.collectionView!(self.collectionView!, layout: self, insetForSectionAtIndex: indexPath.row))! as UIEdgeInsets
        
        var col = 0
        var shortHeight = colArray[col] as! Float
        for(var i = 0;i<colArray.count;i++){
            
            let height = colArray[i] as! Float
            if( height < shortHeight){
                shortHeight =  height
                col = i
            }
        }
        
        let top = colArray[col] as! CGFloat
        
        
        let frame_X = edgeInsets.left + CGFloat(col) * (edgeInsets.left + itemSize.width) as CGFloat
        let frame = CGRect(x: frame_X, y: top + edgeInsets.top, width: itemSize.width, height: itemSize.height)
        
        colArray.replaceObjectAtIndex(col, withObject: top + edgeInsets.top + itemSize.height)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
    }
}
