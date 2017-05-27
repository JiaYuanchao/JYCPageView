//
//  UIColor-Extention.swift
//  JYCPageView
//
//  Created by 贾远潮 on 2017/4/12.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

extension UIColor {
    class var  randomColor : UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256)) / 256.0, green: CGFloat(arc4random_uniform(256)) / 256.0, blue: CGFloat(arc4random_uniform(256)) / 256.0, alpha: 1.0)
    }
}
