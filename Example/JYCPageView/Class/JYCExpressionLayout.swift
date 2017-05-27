//
//  JYCExpressionLayout.swift
//  JYCPageView
//
//  Created by 贾远潮 on 2017/4/26.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class JYCExpressionLayout: UICollectionViewFlowLayout {

    var cols : Int = 4
    var rows : Int = 3
    
    fileprivate var pageCount = 0
    
    fileprivate var layoutArray = [UICollectionViewLayoutAttributes]()
}

extension JYCExpressionLayout {
    override func prepare() {
        
        guard let collectionView = collectionView else {
            return
        }
        
        let viewW : CGFloat = collectionView.bounds.size.width
        let viewH : CGFloat = collectionView.bounds.size.height
        let top : CGFloat = self.sectionInset.top
        let left : CGFloat = self.sectionInset.left
        let bottom : CGFloat = self.sectionInset.bottom
        let right : CGFloat = self.sectionInset.right
        let itemMargin : CGFloat = self.minimumInteritemSpacing
        let lineMargin : CGFloat = self.minimumLineSpacing
        
        let itemW : CGFloat = (viewW - left - right - CGFloat(cols - 1) * itemMargin) / CGFloat(cols)
        let itemH : CGFloat = (viewH - top - bottom - CGFloat(rows - 1) * lineMargin) / CGFloat(rows)
        
        
        let sectionCount = collectionView.numberOfSections
        for sectionIndex in 0..<sectionCount {
            
            let itemCount = collectionView.numberOfItems(inSection: sectionIndex)
            
            for itemIndex in 0..<itemCount {
                let indexPath : IndexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let cellAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                let pageIndex = itemIndex / (cols * rows)
                let currentPageIndex = itemIndex % (cols * rows)
                
                
                let currentLineIndex = currentPageIndex / cols
                let currentRowIndex = currentPageIndex % cols
                
                
                let itemY : CGFloat = top + CGFloat(itemH + lineMargin) * CGFloat(currentLineIndex)
                let itemX : CGFloat = CGFloat(pageCount + pageIndex) * viewW + left + (itemW + itemMargin) * CGFloat(currentRowIndex)

                cellAttr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                layoutArray.append(cellAttr)
            }
            pageCount += ((itemCount - 1) / (cols * rows)) + 1
        }
        
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutArray
    }
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: CGFloat(pageCount) * collectionView!.bounds.size.width, height: 0)
    }

}
