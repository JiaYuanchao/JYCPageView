//
//  JYCTitleView.swift
//  JYCPageView
//
//  Created by 贾远潮 on 2017/4/11.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

protocol JYCTitleViewDelegate : class {
    func titleView(_ titleView : JYCTitleView, didSelected currentIndex : Int)
}

class JYCTitleView: UIView {
    
    weak var delegate : JYCTitleViewDelegate?
    
    fileprivate var titleLabelArray : [UILabel] = [UILabel]()
    fileprivate var currentSelectIndex : Int = 0
    
    fileprivate var titles : [String] = [String]()
    fileprivate var pageStyle : JYCPageViewStyle = JYCPageViewStyle()
    
    fileprivate lazy var titleScrollView : UIScrollView = {
        let scrollView : UIScrollView = UIScrollView(frame: self.bounds)
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.green
        return scrollView
    }()
    
    
    init(frame: CGRect, titles : [String] , pageStyle : JYCPageViewStyle) {
        self.titles = titles
        self.pageStyle = pageStyle
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension JYCTitleView {
    fileprivate func setUI() -> Void {
        self.backgroundColor = UIColor.orange
        addSubview(titleScrollView)
        
        setLabel()
        
        setLabelFrame()
        
    }
    
    private func setLabel(){
        
        let titleCount : Int = titles.count
        
        for i in (0..<titleCount) {
            
            let titleLabel : UILabel = UILabel()
            titleLabel.text = titles[i]
            titleLabel.textColor = i == 0 ? pageStyle.selectTitleColor : pageStyle.noSelectTitleColor
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: pageStyle.titleFont)
            titleLabel.tag = i
            titleLabel.sizeToFit()
            titleScrollView.addSubview(titleLabel)
            titleLabelArray.append(titleLabel)
            
            let tapGR : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGRAction(_:)))
            titleLabel.addGestureRecognizer(tapGR)
            titleLabel.isUserInteractionEnabled = true
            
        }
    }
    
    private func setLabelFrame(){
        guard titleLabelArray.count > 0 else {
            return
        }
        let titleCount : Int = titleLabelArray.count
        for (i, titleLabel) in titleLabelArray.enumerated() {
            var labX : CGFloat = 0
            let labY : CGFloat = 0
            var labW : CGFloat = titleLabel.bounds.width
            let labH : CGFloat = pageStyle.titleHeight
            
            if pageStyle.titleIsRoll {
                
                labX = i == 0 ? 0.5 * pageStyle.titleSpace :  (titleLabelArray[i-1].frame.maxX + pageStyle.titleSpace)
            } else {
                labW = bounds.width / CGFloat(titleCount)
                labX = CGFloat(i) * labW
            }
            
            titleLabel.frame = CGRect(x: labX, y: labY, width: labW, height: labH)
            
        }
        if pageStyle.titleIsRoll {
            titleScrollView.contentSize.width = titleLabelArray.last!.frame.maxX + pageStyle.titleSpace * 0.5
        }
    }
    
    @objc private func tapGRAction(_ tap : UITapGestureRecognizer){
        guard let label : UILabel = (tap.view as? UILabel) else {
            return
        }
        guard currentSelectIndex != label.tag else {
            return
        }
        
        let lastLabel = titleLabelArray[currentSelectIndex]
        
        lastLabel.textColor = pageStyle.noSelectTitleColor
        
        label.textColor = pageStyle.selectTitleColor
        
        currentSelectIndex = label.tag
        
        delegate?.titleView(self, didSelected: currentSelectIndex)
        
        selectLabelScrollToCenter(selectLabel: label)
        
        print(label.tag)
    }
    
    fileprivate func selectLabelScrollToCenter(selectLabel : UILabel){
        guard pageStyle.titleIsRoll else {
            return
        }
        
        var contentOffsetX = selectLabel.center.x - bounds.width * 0.5
        if contentOffsetX < 0 {
            contentOffsetX = 0
        }
        
        if contentOffsetX > titleScrollView.contentSize.width - bounds.width {
            contentOffsetX = titleScrollView.contentSize.width - bounds.width
        }
        
        let offset : CGPoint = CGPoint(x: contentOffsetX, y: 0)
        titleScrollView.setContentOffset(offset, animated: true)

    }
}

extension JYCTitleView : JYCContentViewDelegate {
    func contentView(_ contentView: JYCContentView, currentIndex: Int, targetIndex: Int) {
        self.currentSelectIndex = targetIndex
        let currentLabel = titleLabelArray[currentIndex]
        let targetLabel = titleLabelArray[targetIndex]
        
        currentLabel.textColor = pageStyle.noSelectTitleColor
        
        targetLabel.textColor = pageStyle.selectTitleColor
        
        selectLabelScrollToCenter(selectLabel: targetLabel)
    }
}

extension JYCTitleView {
    open func setSeletTitleWitnIndex(_ index : Int){
    
        let currentLabel = titleLabelArray[self.currentSelectIndex]
        let targetLabel = titleLabelArray[index]
        currentLabel.textColor = pageStyle.noSelectTitleColor
        
        targetLabel.textColor = pageStyle.selectTitleColor
        
        selectLabelScrollToCenter(selectLabel: targetLabel)
        self.currentSelectIndex = index
    }
}
















