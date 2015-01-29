//
//  ViewController.swift
//  scanForTwo-dimensionCode
//
//  Created by 金 on 15/1/28.
//  Copyright (c) 2015年 jinhua. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var messageLabel: UILabel!
    var captureSession:AVCaptureSession?
    var vidioPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //圈住二维码方框
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 1
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
        
        let captureDeviece = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)//代表物理上视频设备
        
        var error:NSError?
        let input:AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDeviece, error: &error)
        if(error != nil){
            println("\(error?.localizedDescription)")
        }
        
        captureSession = AVCaptureSession()
        captureSession!.addInput(input as AVCaptureInput)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
        
        vidioPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        vidioPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        vidioPreviewLayer?.frame = view.layer.bounds;
        view.layer.insertSublayer(vidioPreviewLayer, below: messageLabel.layer)
        
        captureSession?.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if(metadataObjects == nil || metadataObjects.count == 0){
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = "no code is detected"
            return
        }
        
        let metadataObj = metadataObjects[0] as AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode{
            
            let barCodeObject = vidioPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds
            
            if metadataObj.stringValue != nil{
                messageLabel.text = metadataObj.stringValue!
            }
        }
        
    }

}

