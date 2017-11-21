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
            memeGalleryButton.isEnabled = false
            cancelButtonDistanceFromTop.constant = -60.0
            topCaptionDistanceFromCancelButton.constant = 45.0
            bottomCaptionDistanceFromCameraButton.constant = 15.0
            
            do
            {
                // Identify available capture device and add it as the input for a capture session
                let cameraInput = try AVCaptureDeviceInput(device: captureDevice)
                captureSession = AVCaptureSession()
                captureSession?.addInput(cameraInput)
                
                // Configure the preview layer that will handle the live video stream (capture session)
                cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
                
                // Add the preview layer to the preview view and customize it
                cameraPreviewView.layer.addSublayer(cameraPreviewLayer!)
                cameraPreviewView.autoresizesSubviews = true
                cameraPreviewView.frame = view.bounds
                
                // Configure the capture session to accept as output a photo
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
        let memeCaptionAttributes: [String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 50)!,
            NSAttributedStringKey.strokeWidth.rawValue: -6.00]
        
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
    }
}
