//
//  CameraViewController+SetupInterface.swift
//  MemeMe
//
//  Created by Jase-Omeileo West on 11/5/17.
//  Copyright © 2017 Omeileo. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

extension CameraViewController
{
    // MARK: Configure Camera and Views for Capturing and Showing Live Camera Feed
    func setupCamera()
    {
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        {
            primaryActionButton.isEnabled = true
            bottomCaptionDistanceFromCameraButton.constant = 15.0
            
            do
            {
                let cameraInput = try AVCaptureDeviceInput(device: captureDevice)
                captureSession = AVCaptureSession()
                captureSession?.addInput(cameraInput)
                
                cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                cameraPreviewLayer?.connection?.videoOrientation = .portrait
                cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
                cameraPreviewLayer?.frame = cameraPreviewView.layer.bounds
                
                cameraPreviewView.layer.addSublayer(cameraPreviewLayer!)
                cameraPreviewView.autoresizesSubviews = true
                
                capturePhotoOutput = AVCapturePhotoOutput()
                capturePhotoOutput?.isHighResolutionCaptureEnabled = true
                captureSession?.addOutput(capturePhotoOutput!)
                
                captureSession?.startRunning()
            }
            catch
            {
                print(error)
            }
        }
        else
        {
            primaryActionButton.isEnabled = false
            primaryActionButton.isHidden = true
            bottomCaptionDistanceFromCameraButton.constant = -65.0
        }
    }
    
    // MARK: Configure Captions for User to Edit
    func setupCaptions()
    {
        // Set up character attributes for text
        let memeCaptionAttributes: [String : Any] = [
            kCTStrokeColorAttributeName as String: UIColor.black,
            kCTForegroundColorAttributeName as String: UIColor.white,
            kCTFontAttributeName as String: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            kCTStrokeWidthAttributeName as String: 5.0
        ]
        
        // Set up text fields
        memeTopCaptionTextField.defaultTextAttributes = memeCaptionAttributes
        memeBottomCaptionTextField.defaultTextAttributes = memeCaptionAttributes
        
        memeTopCaptionTextField.placeholder = ""
        memeTopCaptionTextField.textAlignment = .center
        memeTopCaptionTextField.adjustsFontSizeToFitWidth = true
        memeBottomCaptionTextField.placeholder = ""
        memeBottomCaptionTextField.adjustsFontSizeToFitWidth = true
        memeBottomCaptionTextField.textAlignment = .center
        
        enableCaptions(false)
    }
    
    // MARK: Setup Buttons for First Use
    func setupButtons()
    {
        primaryActionButton.isSelected = false
        primaryActionButton.setImage(#imageLiteral(resourceName: "Camera-Released-No-Shadow"), for: .normal)
        primaryActionButton.setImage(#imageLiteral(resourceName: "Camera-Tapped-No-Shadow"), for: .highlighted)
        cancelMemeButton.isHidden = true
        secondaryActionButtons.isHidden = true
        //topCaptionDistanceFromCancelButton.constant = 10.0
    }
}
