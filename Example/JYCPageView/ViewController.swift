//
//  ViewController.swift
//  JYCPageView
//
//  Created by jiayuanchao on 04/10/2017.
//  Copyright (c) 2017 jiayuanchao. All rights reserved.
//

import UIKit

let kCollectionViewCellID = "kCollectionViewCellID"


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
//        let pageViewStyle : JYCPageViewStyle = JYCPageViewStyle()
////        pageViewStyle.titleIsRoll = false
//        let pageRect : CGRect = CGRect(x:0,y:64,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height - 64)
//        
//        let titles : [String] = ["推荐","电视剧","电影","动漫","综艺","电影","电影电影","动漫","推荐","电视剧","电影","动漫","综艺","电影","电影电影","动漫"]
////        let titles : [String] = ["推荐","电视剧","电影","动漫","综艺","电影","电影电影","动漫"]
//
//        var childVc : [UIViewController] = [UIViewController]()
//        
//        for _ in titles {
//            let vc : UIViewController = UIViewController()
//            vc.view.backgroundColor = .randomColor
//            childVc.append(vc)
//        }
//        
//        let pageView : JYCPageView = JYCPageView(frame: pageRect, titles: titles, childVcs: childVc, pageViewStyle: pageViewStyle, parentVc : self)
//        pageView.backgroundColor = UIColor.red
//        view.addSubview(pageView)
        
        
        let pageViewStyle : JYCPageViewStyle = JYCPageViewStyle()
        pageViewStyle.titleIsRoll = false
        
        let pageRect : CGRect = CGRect(x:0,y:64,width:UIScreen.main.bounds.width,height:300)
        
        let titles : [String] = ["推荐","电视剧","电影","动漫"]
        
        let layout = JYCExpressionLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20)
        layout.cols = 4
        layout.rows = 3
        
        let pageView : JYCPageView = JYCPageView(frame: pageRect, pageViewStyle: pageViewStyle, titles: titles ,layout: layout)
        pageView.backgroundColor = UIColor.red
        pageView.register(cellClass: UICollectionViewCell.self, forCellWithReuseIdentifier: kCollectionViewCellID)
        pageView.dataSource = self
        pageView.delegate = self
        view.addSubview(pageView)
        
    }

}

extension ViewController : JYCPageViewDataSource {
    func numberOfSections(in pageView: JYCPageView) -> Int {
        return 4
    }
    func pageView(_ pageView: JYCPageView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 16
        case 2:
            return 14
        case 3:
            return 20
        case 1:
            return 23
        default:
            return 13
        }
    }
    func pageView(_ pageView: JYCPageView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pageView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor
        return cell
    }
}

extension ViewController : JYCPageViewDelegate {
    func pageView(_ pageView: JYCPageView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath)被点击了")
    }
}

