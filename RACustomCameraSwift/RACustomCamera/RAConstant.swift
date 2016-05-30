//
//  Constant.swift
//  SwiftWeiBo
//
//  Created by ZCBL on 16/5/17.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import Foundation

import UIKit


/**
 屏幕宽度
 
 - returns: 屏幕宽度
 */
public func kRAMainScreenW() -> CGFloat {
    
   return UIScreen.mainScreen().bounds.size.width
    
}
/**
 屏幕高度
 
 - returns: 屏幕高度
 */
public func kRAMainScreenH() -> CGFloat {

    return UIScreen.mainScreen().bounds.size.height
}

/**
 屏幕size
 
 - returns: 屏幕size
 */
public func kRAMainScreenSize() -> CGSize {

    return UIScreen.mainScreen().bounds.size
}

/**
 获取系统版本
 
 - returns: 系统版本  字符串
 */
public func kRASystemVersion() -> String{

    return UIDevice.currentDevice().systemVersion
}