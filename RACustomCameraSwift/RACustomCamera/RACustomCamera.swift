//
//  RACustomCamera.swift
//  RACustomCameraSwift
//
//  Created by Rocky on 16/5/27.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

/// 硬件类型
///
/// - video: 视频
/// - audio: 音频
/// - muxed: 混合
enum cameraDevice:Int {
    case video = 0
    case audio = 1
    case muxed = 2
}

/// 闪光灯模式
///
/// - on:   闪光灯开
/// - off:  闪光等关闭
/// - auto: 闪光灯自动
enum cameraFlashMode:Int {
    case on = 0
    case off = 1
    case auto = 2
}


enum returnCameraFlashMode:Int {
    case on = 0
    case off = 1
    case auto = 2
    case noFlash = 3
}

/// 摄像头类型
///
/// - backCamera:  后置摄像头
/// - frontCamera: 前置摄像头
/// - none:        无
enum cameraType : Int{
    
    case backCamera = 0
    case frontCamera = 1
    case none = 2
}

class RACustomCamera: NSObject {
    
    typealias callBackWithImage = ((image:UIImage)->())
    typealias callBackWithVideo = (()->())
    
   

    
    /// 是否允许自动保存图片\视频到相册 默认值true
    internal var enableAutoSave:Bool = true
    
    /// 允许创建新的相册 默认值false
    internal var allowNewPhotoBrowser:Bool = false
    
    ///单例
    internal static let shareCamera:RACustomCamera = {
        
        let camera = RACustomCamera()
        
        return camera
    }()
    
    
    private var session:AVCaptureSession!
    private var inputDevice:AVCaptureDeviceInput!
    private var imageOutput:AVCaptureStillImageOutput!
    private var priviewLayer:AVCaptureVideoPreviewLayer!
    
    ///是否正在使用前置摄像头
    private var isUsingFrontCamera:Bool = false
    /// 当前控制器
    private var currentVc:UIViewController?
    
    override init() {
        super.init()
        
        installCameraDevice()
    }
    
}

// MARK: - public method
extension RACustomCamera {

    ///  添加预览图层
    ///
    ///  - parameter currentViewController: 当前控制器
    ///  - parameter view:                  添加到哪个view上
    ///  - parameter frame:                 尺寸
    internal func addPrviewLayerToView(currentViewController:UIViewController!,view:UIView!,frame:CGRect!) -> Void{
        
        assert(currentViewController != nil, "currentViewController can not be nil")
        assert(view != nil, "view can not be nil")
        assert(frame != nil, "frame can not be nil")
    
        priviewLayer.frame = frame
        currentVc = currentViewController
        view.layer.masksToBounds = true
        view.layer.insertSublayer(priviewLayer, atIndex: 0)
     
    }
    
    /// 启动相机
    internal func startCamera() -> Void{
        
        if session.running == false {
            
            session.startRunning()
            
            if session.running != true {
                
                printRALog("相机启动失败")
            }
        }
    }
    
    /// 关闭相机
    internal func stopCamera() -> Void {
        
        if session.running == true {
            
            session.stopRunning()
            
            if session.running == true {
                
                printRALog("相机关闭失败")
            }
        }
    }
    
    ///  闪光灯切换（每次调用按顺序切换闪光灯模式，默认 auto）
    ///
    /// - returns: 切换类型
    internal func autoSwitchFlashMode() -> returnCameraFlashMode{
    
        let defaultDevice = swichDevice()
        
        do{
            
            try defaultDevice.lockForConfiguration()
            
        }catch let error as NSError{
            
            printRALog("\(error)")
        }
        
        
        if defaultDevice.hasFlash == false {
            
            printRALog("设备没有闪光灯")
            return .noFlash
        }
        
        if defaultDevice.flashMode == .Off {
            
            switchFlashMode(.on)
            
            return .on
            
        }else if defaultDevice.flashMode == .On{
        
            switchFlashMode(.auto)
            
            return .auto
            
        }else if defaultDevice.flashMode == .Auto{
        
            switchFlashMode(.off)
            
            return .off
            
        }else{
        
            return .auto
        }
    }
    
    /// 切换指定闪光灯模式
    ///
    /// - parameter flashMode: 默认为auto
    internal func switchFlashMode(flashMode:cameraFlashMode = .auto){
        
        let captureDevice = swichDevice()
        
        do{
        
            try captureDevice.lockForConfiguration()
            
        }catch let error as NSError{
        
            printRALog("\(error)")
        }
        
        
        if captureDevice.hasFlash == false {
            
            printRALog("设备没有闪光灯")
            return
        }
        
        switch flashMode {
        case .on:
            captureDevice.flashMode = .On
            break
        case .off:
            captureDevice.flashMode = .Off
            break
        case .auto:
            captureDevice.flashMode = .Auto
        }
        
        captureDevice.unlockForConfiguration()
    }
    
    /// 切换摄像头
    ///
    /// - parameter type: 前置或后置 默认为自动切换
    internal func swithCamera(type:cameraType = .none){
    
        var desiredPosition:AVCaptureDevicePosition
        
        if isUsingFrontCamera == true {
            
            desiredPosition = AVCaptureDevicePosition.Back
        }else{
        
            desiredPosition = AVCaptureDevicePosition.Front
        }
        
        
        for singleDevice:AVCaptureDevice in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! Array {
            
            printRALog("\(singleDevice.localizedName)")
            
            if singleDevice.position == desiredPosition {
                
                session.beginConfiguration()
                
                session.removeInput(inputDevice)
                
                let input = try! AVCaptureDeviceInput(device: singleDevice)
                
                if session.canAddInput(input) {
                    
                    session.addInput(input)
                }
            }
        }
        
        
    }
    
    /// 拍照
    ///
    /// - parameter finishedWithImage: 回调
    internal func takePhoto(finishedWithImage:callBackWithImage?){
        
        if RAAuthorizationStatusTool.availibleCamera(.audio) == false {
            
            printRALog("无相机使用权限")
            
            return
        }
        
        let captureConnetion = imageOutput.connectionWithMediaType(switchMeiaType(.video))
        
        imageOutput.captureStillImageAsynchronouslyFromConnection(captureConnetion) { (imageBuffer,error) in
            
            let jpegData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageBuffer)
            
            let jpegImage = UIImage(data: jpegData)
        
            finishedWithImage?(image: jpegImage!)
            
            
            //未完成
        }
        
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
        
            printRALog("\(error)")
        }
        
        imageOutput = AVCaptureStillImageOutput()
        
        imageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        
        if session.canAddInput(inputDevice) == true {
            
            session.addInput(inputDevice)
            
        }else{
        
            printRALog("添加输入设备失败")
        }
        
        if session.canAddOutput(imageOutput) == true {
            
            session.addOutput(imageOutput)
        }else{
        
            printRALog("添加输出设备失败")
        }
        
        priviewLayer = AVCaptureVideoPreviewLayer(session:session)
        priviewLayer.videoGravity = AVLayerVideoGravityResizeAspect
        
        let defaultDevice = swichDevice()
        
        do{
            
            try defaultDevice.lockForConfiguration()
            
        }catch let error as NSError{
            
            printRALog("\(error)")
        }
        
        
        if defaultDevice.hasFlash == false {
            
            printRALog("设备没有闪光灯")
            return
        }
        
        defaultDevice.flashMode = AVCaptureFlashMode.Auto

        defaultDevice.unlockForConfiguration()
        
      
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