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
    @IBOutlet weak var memeBottomCaptionTextField: UITextField!
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    @IBOutlet weak var memeGalleryButton: UIBarButtonItem!
    @IBOutlet weak var secondaryActionButtons: UIStackView!
    @IBOutlet weak var cancelMemeButton: UIButton!
    
    @IBOutlet weak var primaryActionButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var primaryActionButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var primaryActionButtonXCoord: NSLayoutConstraint!
    @IBOutlet weak var memeTopCaptionTextField: UITextField!
    @IBOutlet weak var primaryActionButtonDistanceFromBottom: NSLayoutConstraint!
    @IBOutlet weak var memeBottomCaptionConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolbarDistanceFromBottom: NSLayoutConstraint!
    @IBOutlet weak var secondaryButtonsDistanceFromBottom: NSLayoutConstraint!
    
    var captureSession: AVCaptureSession?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    var completedMeme: UIImage?
    var memeImage: UIImage?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        cancelMemeButton.isHidden = true
        primaryActionButton.setImage(#imageLiteral(resourceName: "Camera-Tapped-No-Shadow"), for: .highlighted)
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
    
    func configureMemeCreationUI()
    {
        // Configure UI
        configureView()
        
        // Display captured image in UI
    }
    
    func configureView()
    {
        // End live camera capture session
        captureSession?.stopRunning()
        
        // Animate primary button and toolbar
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
            self.primaryActionButtonXCoord.constant = 130
            self.primaryActionButtonDistanceFromBottom.constant = 20
            self.primaryActionButtonHeight.constant -= 130
            self.primaryActionButtonWidth.constant -= 130
            self.toolbarDistanceFromBottom.constant += 44
            self.secondaryButtonsDistanceFromBottom.constant = 20
            
            self.view.layoutIfNeeded()
        }) { (true) in
            // Show secondary action buttons
            self.primaryActionButton.isSelected = true
            self.secondaryActionButtons.isHidden = false
        }
        
        primaryActionButton.setImage(#imageLiteral(resourceName: "Send"), for: [.highlighted, .selected])
        
        cancelMemeButton.isHidden = false
        memeTopCaptionTextField.isEnabled = true
        memeBottomCaptionTextField.isEnabled = true
    }
    
    func animatePrimaryActionButton()
    {
        
    }
    
    func addImageToView(image: UIImage)
    {
        let imageView = UIImageView(image: image)
        imageView.frame = cameraPreviewView.frame
        cameraPreviewView.addSubview(imageView)
        
        configureView()
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
        let imageSourceType: UIImagePickerControllerSourceType = .photoLibrary
        handleImageSelection(imageSourceType: imageSourceType)
    }
    
    @IBAction func editMemeCaption(_ sender: Any)
    {
        
    }
    
    @IBAction func downloadMeme(_ sender: UIButton)
    {
        if let memeImage = memeImage
        {
            // Allow download of meme if both Caption fields contain text
            UIImageWriteToSavedPhotosAlbum(memeImage, nil, nil, nil)
        }
    }
    
    @IBAction func cancelMeme(_ sender: UIButton)
    {
        
    }
}

