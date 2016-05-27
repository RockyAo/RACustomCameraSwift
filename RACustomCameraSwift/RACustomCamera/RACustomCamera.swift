//
//  RACustomCamera.swift
//  RACustomCameraSwift
//
//  Created by ZCBL on 16/5/27.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import UIKit
import AVFoundation

enum cameraDevice:Int {
    case video = 0
    case audio = 1
    case muxed = 2
}

class RACustomCamera: NSObject {
    
    private var session:AVCaptureSession!
    private var inputDevice:AVCaptureDeviceInput!
    private var imageOutput:AVCaptureStillImageOutput!
    private var priviewLayer:AVCaptureVideoPreviewLayer!
}
extension RACustomCamera {

    internal func addPrviewLayerToView(view:UIView!,frame:CGRect!) -> Void{
    
        priviewLayer.frame = frame
        view.layer.masksToBounds = true
        view.layer.addSublayer(priviewLayer)
    }
}

// MARK: - 初始化相机相关
extension RACustomCamera {
    
    /// 加载相机相关
    private func installCameraDevice(){
    
        session = AVCaptureSession()
        
        do{
            
          try
            
          inputDevice = AVCaptureDeviceInput(device:swichDevice())
            
        }catch let error as NSError{
        
            print(error)
        }
        
        imageOutput = AVCaptureStillImageOutput()
        imageOutput.setValue(AVVideoCodecJPEG, forKey: AVVideoCodecKey)
        
        if session.canAddInput(inputDevice) == true {
            
            session.addInput(inputDevice)
        }
        
        if session.canAddOutput(imageOutput) == true {
            
            session.addOutput(imageOutput)
        }
        
        priviewLayer = AVCaptureVideoPreviewLayer(session:session)
        priviewLayer.videoGravity = AVLayerVideoGravityResizeAspect
        
    }
    
    /// 获取设备
    ///
    /// - parameter deviceType: 设备类型 默认为视频
    ///
    /// - returns: 设备
    private func swichDevice(deviceType:cameraDevice = .video) -> AVCaptureDevice{
    
        let device = AVCaptureDevice.defaultDeviceWithMediaType(switchMeiaType(deviceType))
        
        return device
    }
    
    /// 获取设备类型
    ///
    /// - parameter deviceType: 设备类型枚举
    ///
    /// - returns: 设备类型字符串
    private func switchMeiaType(deviceType:cameraDevice) -> String{
    
        switch deviceType{
            
        case .video:
            
            return AVMediaTypeVideo
        case .audio:
            
            return AVMediaTypeAudio
            
        case .muxed:
            
            return AVMediaTypeMuxed
        }
    }
    
}