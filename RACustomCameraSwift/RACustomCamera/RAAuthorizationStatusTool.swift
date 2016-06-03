//
//  RAAuthorizationStatusTool.swift
//  RACustomCameraSwift
//
//  Created by ZCBL on 16/6/3.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

enum mediaType:Int {
    case video = 0
    case audio = 1
}

class RAAuthorizationStatusTool: NSObject {
 
    /// 是否拥有相机权限
    ///
    /// - parameter Type: 相机类型（默认为  video 可选 audio）
    ///
    /// - returns: true / false
    class internal func availibleCamera(Type:mediaType = .video) -> Bool {
        
        var authorizationStatus:AVAuthorizationStatus
        
        if Type == .video {
            
            authorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)

        }else{
        
            authorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeAudio)

        }
        
        if authorizationStatus == .Restricted || authorizationStatus == .Denied {
            
            return false
            
        }else{
        
            return true
        }
        
    }
    
    /// 是否拥有相册使用权限
    ///
    /// - returns: true/false
    class internal func availiblePhotoAlbum() -> Bool{
    
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        if authorization != .Authorized{
            
            PHPhotoLibrary.requestAuthorization({ (PHAuthorizationStatus) in
                
                print(PHAuthorizationStatus)
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == .Denied || PHPhotoLibrary.authorizationStatus() == .Restricted {
            
            print("false 写入相册失败,无相册使用权限")
            
            return false
        }else{
        
            return true
        }
    
    }
    
    
}
