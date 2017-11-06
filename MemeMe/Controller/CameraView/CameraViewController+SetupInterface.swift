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
            cancelButtonDistanceFromTop.constant = -60.0
            topCaptionDistanceFromCancelButton.constant = 45.0
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
        // Set up text fields
        for caption in memeCaptions
        {
            configureCaption(textField: caption)
        }
        
        enableCaptions(false)
    }
    
    func configureCaption(textField: UITextField)
    {
        textField.defaultTextAttributes = memeCaptionAttributes
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = true
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
