//
//  JYCPageView.swift
//  JYCPageView
//
//  Created by 贾远潮 on 2017/4/10.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

protocol JYCPageViewDataSource : class {
    
    func numberOfSections(in pageView : JYCPageView) -> Int
    
    func pageView(_ pageView: JYCPageView, numberOfItemsInSection section: Int) -> Int
    
    func pageView(_ pageView: JYCPageView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell

}

protocol JYCPageViewDelegate : class {
    func pageView(_ pageView: JYCPageView, didSelectItemAt indexPath: IndexPath)
}


class JYCPageView : UIView {
    
    weak var dataSource : JYCPageViewDataSource?
    weak var delegate : JYCPageViewDelegate?
    
    fileprivate var titles : [String] = [String]()
    
    fileprivate var childVcs : [UIViewController]!
    
    fileprivate var parentVc : UIViewController!
    
    fileprivate var layout : JYCExpressionLayout!
    
    fileprivate var pageViewStyle : JYCPageViewStyle = JYCPageViewStyle()
    
    fileprivate var currentSection : Int = 0
    
    
    fileprivate lazy var titleView : JYCTitleView = {
        let titleRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.pageViewStyle.titleHeight)
        let titleView : JYCTitleView = JYCTitleView(frame: titleRect, titles: self.titles, pageStyle: self.pageViewStyle)
        return titleView
    }()
    
    fileprivate lazy var contentView : JYCContentView = {
        let contentRect = CGRect(x: 0, y: self.pageViewStyle.titleHeight, width: self.bounds.width, height: self.bounds.height - self.pageViewStyle.titleHeight)
        let contetView = JYCContentView(frame: contentRect, childVcs: self.childVcs, parentVc:self.parentVc)
        return contetView
    }()
    
    fileprivate lazy var collectionView : UICollectionView = {
        
        let collectionViewFrame = CGRect(x: 0, y: self.pageViewStyle.titleHeight, width: self.bounds.width, height: self.bounds.height - self.pageViewStyle.titleHeight - self.pageViewStyle.pageControlHeight)
        let collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: self.layout)
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    fileprivate lazy var pageControl : UIPageControl = {
        let pageControlFrame = CGRect(x: 0, y: self.bounds.height - self.pageViewStyle.pageControlHeight, width: self.bounds.width, height: self.pageViewStyle.pageControlHeight)
        let pageControl = UIPageControl(frame: pageControlFrame)
        return pageControl
    }()
    
    init(frame: CGRect, titles:[String], childVcs:[UIViewController] , pageViewStyle : JYCPageViewStyle, parentVc: UIViewController) {
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.pageViewStyle = pageViewStyle
        super.init(frame: frame)
        setContentUI()
    }
    
    init(frame: CGRect, pageViewStyle: JYCPageViewStyle, titles:[String],layout : JYCExpressionLayout) {
        self.titles = titles
        self.pageViewStyle = pageViewStyle
        self.layout = layout
        super.init(frame: frame)
        setCollectionUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JYCPageView {
    fileprivate func setContentUI(){
        addSubview(titleView)
        addSubview(contentView)
        
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
    fileprivate func setCollectionUI(){
        addSubview(titleView)
        addSubview(collectionView)
        addSubview(pageControl)
        
        titleView.delegate = self
    }
}

extension JYCPageView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount =  dataSource?.pageView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            pageControl.currentPage = 0
        }
        return itemCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageView(self, cellForItemAt: indexPath)
    }
}

extension JYCPageView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageView(self, didSelectItemAt: indexPath)
    }
    
}

extension JYCPageView : JYCTitleViewDelegate {
    func titleView(_ titleView: JYCTitleView, didSelected currentIndex: Int) {
        let sectionIndex = IndexPath(item: 0, section: currentIndex)
        collectionView.scrollToItem(at: sectionIndex, at: .left, animated: false)
        collectionView.contentOffset.x -= self.layout.sectionInset.left
        
        currentSection = currentIndex
        
        let itemCount = dataSource?.pageView(self, numberOfItemsInSection: currentIndex) ?? 0
        pageControl.numberOfPages =  (itemCount - 1) / (layout.cols * layout.rows) + 1
        pageControl.currentPage = 0
    }
}

extension JYCPageView : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewScroll()
        }
    }
    fileprivate func scrollViewScroll(){
        let currentPoint = CGPoint(x: collectionView.contentOffset.x + layout.sectionInset.left, y: layout.sectionInset.top)
        guard let itemIndex = collectionView.indexPathForItem(at: currentPoint) else {
            return
        }
        if itemIndex.section != currentSection {
            let itemCount = dataSource?.pageView(self, numberOfItemsInSection: itemIndex.section) ?? 0
            pageControl.numberOfPages =  (itemCount - 1) / (layout.cols * layout.rows) + 1
            titleView.setSeletTitleWitnIndex(itemIndex.section)
            currentSection = itemIndex.section
        }
        
        let currentPage = itemIndex.row / Int(layout.cols * layout.rows)
        pageControl.currentPage = currentPage
    }
}

extension JYCPageView {
    
    func register(cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String){
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func register(nib: UINib?, forCellWithReuseIdentifier identifier: String){
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell{
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }


}
