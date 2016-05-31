//
//  RAPhotoSaveTool.swift
//  RACustomCameraSwift
//
//  Created by ZCBL on 16/5/31.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import UIKit
import Photos

class RAPhotoSaveTool: NSObject {
    
    
    /// 存储图片data
    ///
    /// - parameter photoData:      图片数据
    /// - parameter photoBrowsName: 相册名称（不传默认系统相册）
    ///
    /// - returns: 成功失败
    internal class func savePhotoData(photoData:NSData!,albumName:String? = "") -> Bool{
    
        
        return true
    }
    
    /// 存储图片
    ///
    /// - parameter photo:             图片（UIImage）
    /// - parameter photobrowsersName: 相册名称（不传默认系统相册）
    ///
    /// - returns: 成功失败
    internal class func savePhoto(photo:UIImage!,albumName:String? = "") -> Bool {
        
        return true
    }
    
}

// MARK: - private method
extension RAPhotoSaveTool {

    private class func savePhoto(data:NSData!,needNewalbum:Bool = false,albumName:String? = "") -> Bool{
    
        let photoLibrary = PHPhotoLibrary.sharedPhotoLibrary()
        
        let authorization = PHPhotoLibrary.authorizationStatus()
        
    
        if authorization != .Authorized{
            
            PHPhotoLibrary.requestAuthorization({ (PHAuthorizationStatus) in
                
                print(PHAuthorizationStatus)
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == .Denied || PHPhotoLibrary.authorizationStatus() == .Restricted {
            
            print("false 写入相册失败,无相册使用权限")
            
            return false
        }
        
        
        return true
    }
    
    /// 创建相册
    ///
    /// - parameter albumName: 相册名称
    private class func creatAlbum(albumName:String!){
        

    }
    
    
}
