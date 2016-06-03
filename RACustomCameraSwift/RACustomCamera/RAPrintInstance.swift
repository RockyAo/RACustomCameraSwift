//
//  RAPrintInstance.swift
//  RACustomCameraSwift
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import UIKit

class RAPrintInstance: NSObject {
    
    /// 是否允许打印 default is true
    var enableLog:Bool = true
    
    
    /// 使用单例调用
    internal static let shareInstance:RAPrintInstance = {
        
        let instance = RAPrintInstance()
        
        return instance
    }()

}

// MARK: - public method
extension RAPrintInstance{

    /// 打印用
    ///
    /// - parameter messages: 信息
    internal func printMessages(messages:String!){
        
        if enableLog == true {
            
            print("messages:\(messages)")
        }
    }
    
    /// 是否允许打印
    ///
    /// - parameter enable: true/false default is true
    internal func setLogEnable(enable:Bool = true){
    
        enableLog = enable
    }
}

