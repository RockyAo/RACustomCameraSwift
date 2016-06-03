//
//  RACustomCamera.swift
//  RACustomCameraSwift
//
//  Created by ZCBL on 16/5/27.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

enum cameraDevice:Int {
    case video = 0
    case audio = 1
    case muxed = 2
}


class RACustomCamera: NSObject {
    
    typealias callBackWithImage = ((image:UIImage)->())
    typealias callBackWithVideo = (()->())
    
    private var session:AVCaptureSession!
    private var inputDevice:AVCaptureDeviceInput!
    private var imageOutput:AVCaptureStillImageOutput!
    private var priviewLayer:AVCaptureVideoPreviewLayer!
    
    /// 是否允许自动保存图片\视频到相册 默认值true
    internal var enableAutoSave:Bool = true
    
    /// 允许创建新的相册 默认值false
    internal var allowNewPhotoBrowser:Bool = false
    
    ///单例
    internal static let shareCamera:RACustomCamera = {
        
        let camera = RACustomCamera()
        
        return camera
    }()
    
    override init() {
        super.init()
        
        installCameraDevice()
        
        
    }

}

// MARK: - public method
extension RACustomCamera {


    /// 添加预览图层
    ///
    /// - parameter view:  添加到哪个view上
    /// - parameter frame: 尺寸
    internal func addPrviewLayerToView(view:UIView!,frame:CGRect!) -> Void{
    
        priviewLayer.frame = frame
        view.layer.masksToBounds = true
        view.layer.insertSublayer(priviewLayer, atIndex: 0)
        
    }
    
    /// 启动相机
    internal func startCamera() -> Void{
        
        if session.running == false {
            
            session.startRunning()
        }
    }
    
    /// 关闭相机
    internal func stopCamera() -> Void {
        
        if session.running == true {
            
            session.stopRunning()
        }
    }
    
    internal func takePhoto(finishedWithImage:callBackWithImage?){
        
        if RAAuthorizationStatusTool.availibleCamera(.audio) == false {
            
            print("无相机使用权限")
            return
        }
        
        let captureConnetion = imageOutput.connectionWithMediaType(switchMeiaType(.video))
        
        imageOutput.captureStillImageAsynchronouslyFromConnection(captureConnetion) { (imageBuffer,error) in
            
            let jpegData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageBuffer)
            
            let jpegImage = UIImage(data: jpegData)
        
            
            let author = ALAssetsLibrary.authorizationStatus()
            
            if author == ALAuthorizationStatus.Restricted || author == ALAuthorizationStatus.Denied {
            
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(jpegImage!, self,nil, nil)
            
            
            finishedWithImage?(image: jpegImage!)
            
        }
        
    }
    
    
    func image(image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject)
        
    {
        
        if didFinishSavingWithError != nil
        {
            print("error!")
            
            return
        }
        
        print("image was saved")
        
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
        
        imageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        
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