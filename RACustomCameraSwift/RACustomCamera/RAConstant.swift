//
//  Constant.swift
//
//
//  Created by Rocky on 16/5/17.
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

/// 打印函数
///
/// - parameter messages: 要向控制台输出的信息
/// - parameter file:     哪个文件 不用传
/// - parameter method:   哪个方法 不用传
/// - parameter line:     哪一行  不用传
public func printRALog<T>(messages:T,file:String = #file,method:String = #function,line:Int = #line){
    
    #if DEBUG
        print("\((file as NSString).lastPathComponent),methodName:\(method),[line:\(line)]messages: \(messages)")
    #endif
}