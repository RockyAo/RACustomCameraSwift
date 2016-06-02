//
//  ViewController.swift
//  RACustomCameraSwift
//
//  Created by ZCBL on 16/5/27.
//  Copyright © 2016年 RockyAo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        RACustomCamera.shareCamera.addPrviewLayerToView(view, frame: CGRectMake(0, 0, kRAMainScreenW(), kRAMainScreenH()))
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        RACustomCamera.shareCamera.startCamera()
    
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        RACustomCamera.shareCamera.stopCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePhotoClick(sender: UIBarButtonItem) {
        
        RACustomCamera.shareCamera.takePhoto { (image) in
            
            print("image \(image)")
            
        }
        
    
    }
    
}

