//
//  CameraViewController.swift
//  MemeMe
//
//  Created by Jase-Omeileo West on 10/17/17.
//  Copyright © 2017 Omeileo. All rights reserved.
//  Custom camera setup code reference from: https://github.com/rizwankce/Camera/blob/master/Camera/ViewController.swift

import UIKit
import AVFoundation

class CameraViewController: UIViewController
{
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var primaryActionButton: UIButton!
    @IBOutlet weak var primaryActionButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var primaryActionButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var primaryActionButtonXCoord: NSLayoutConstraint!
    @IBOutlet weak var primaryActionButtonDistanceFromBottom: NSLayoutConstraint!
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    @IBOutlet weak var memeGalleryButton: UIBarButtonItem!
    @IBOutlet weak var memeTopCaptionTextField: UITextField!
    @IBOutlet weak var memeBottomCaptionTextField: UITextField!
    @IBOutlet weak var memeBottomCaptionConstraint: NSLayoutConstraint!
    
    var captureSession: AVCaptureSession?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    @IBOutlet weak var cancelMemeButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        cancelMemeButton.isHidden = true
    }
    
    // MARK: Configure Camera and Views for Capturing and Showing Live Camera Feed
    func setupCamera()
    {
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        {
            do
            {
                let cameraInput = try AVCaptureDeviceInput(device: captureDevice)
                captureSession = AVCaptureSession()
                captureSession?.addInput(cameraInput)
                
                cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                cameraPreviewLayer?.frame = view.layer.bounds
                cameraPreviewView.layer.addSublayer(cameraPreviewLayer!)

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
    }
    
    // MARK: Present Share Options Modally
    func shareMeme(meme: UIImage)
    {
        let shareController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    
    func configureMemeCreationUI(image capturedImage: UIImage)
    {
        captureSession?.stopRunning()
        
        // Display captured image in UI
        
        
        // Configure UI
        UIView.animate(withDuration: 0.4, animations: {
            self.primaryActionButtonXCoord.constant = 130
            self.primaryActionButtonDistanceFromBottom.constant = 20
            self.primaryActionButtonHeight.constant -= 120
            self.primaryActionButtonWidth.constant -= 120
            
            self.view.layoutIfNeeded()
        }) { (true) in
            self.primaryActionButton.isSelected = true
        }
        
        primaryActionButton.setImage(#imageLiteral(resourceName: "Send"), for: .highlighted)
    }
    
    func animatePrimaryActionButton()
    {
        
    }
    
    @IBAction func takePicture(_ sender: UIButton)
    {
        guard let capturePhotoOutput = capturePhotoOutput else {
            return
        }
        
        // MARK: Configure Photo Settings
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg, AVVideoCompressionPropertiesKey: [AVVideoQualityKey: 1.0]])
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        // MARK: Capture Photo with Preconfigured Settings
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func launchGallery(_ sender: Any)
    {
        let galleryController = UIImagePickerController()
        present(galleryController, animated: true, completion: nil)
    }
    
    @IBAction func editMemeCaption(_ sender: Any)
    {
        
    }
    
    @IBAction func cancelMeme(_ sender: UIButton)
    {
        
    }
}

