//
//  JYCContentView.swift
//  JYCPageView
//
//  Created by 贾远潮 on 2017/4/11.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"

protocol JYCContentViewDelegate : class {
    func contentView(_ contentView : JYCContentView, currentIndex : Int, targetIndex : Int)
}

class JYCContentView: UIView {
    
    weak var delegate : JYCContentViewDelegate?
    
    fileprivate var isWholeAction = false

    fileprivate var currentIndex : Int = 0
    fileprivate var childVcs : [UIViewController] = [UIViewController]()
    fileprivate var parentVc : UIViewController = UIViewController()
    fileprivate lazy var contentCV : UICollectionView = {
        let layOutCV : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layOutCV.itemSize = self.bounds.size
        layOutCV.minimumInteritemSpacing = 0
        layOutCV.minimumLineSpacing = 0
        layOutCV.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layOutCV)
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.delegate = self;
        return collectionView
    }()
    
    init(frame: CGRect, childVcs : [UIViewController], parentVc : UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        for vc in childVcs {
            parentVc.addChildViewController(vc)
        }
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JYCContentView {
    fileprivate func setUI(){
        addSubview(contentCV)
    }
}

extension JYCContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        for view  in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        childVcs[indexPath.row].view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVcs[indexPath.row].view)
//        childVcs[indexPath.row].view.backgroundColor = .randomColor
        
        let label = UILabel(frame: cell.contentView.bounds)
        label.text = "\(indexPath.row)"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        cell.contentView.addSubview(label)
        
        return cell
    }
}

extension JYCContentView : JYCTitleViewDelegate {
    func titleView(_ titleView: JYCTitleView, didSelected currentIndex: Int) {
        let offset = CGPoint(x: CGFloat(currentIndex) * bounds.width, y: 0)
        contentCV.setContentOffset(offset, animated: false)
    }
}

extension JYCContentView : UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard isWholeAction else {
            return
        }
        currentIndex = Int(scrollView.contentOffset.x / bounds.width)
        isWholeAction = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            changeTitleView()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        changeTitleView()
    }
    private func changeTitleView(){
        isWholeAction = true
        let targetIndex : Int = Int(contentCV.contentOffset.x / bounds.width)
        delegate?.contentView(self, currentIndex: currentIndex, targetIndex: targetIndex)
    }
}







