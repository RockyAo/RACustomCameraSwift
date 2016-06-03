//
//  RAPrintInstance.swift
//  RACustomCameraSwift
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import UIKit

class RAPrintInstance: NSObject {

    /// 使用单例调用
    internal static let shareInstance:RAPrintInstance = {
        
        let instance = RAPrintInstance()
        
        return instance
    }()

}

// MARK: - public method
extension RAPrintInstance{

    
}

// MARK: - private method
extension RAPrintInstance{

    
}
