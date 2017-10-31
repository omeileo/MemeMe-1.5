//
//  CameraViewController.swift
//  MemeMe
//
//  Created by Jase-Omeileo West on 10/17/17.
//  Copyright © 2017 Omeileo. All rights reserved.
//  Custom camera setup code referenced from: https://github.com/rizwankce/Camera/blob/master/Camera/ViewController.swift

import UIKit
import AVFoundation
import Foundation

class CameraViewController: UIViewController
{
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var primaryActionButton: UIButton!
    @IBOutlet weak var memeBottomCaptionTextField: UITextField!
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    @IBOutlet weak var memeGalleryButton: UIBarButtonItem!
    @IBOutlet weak var secondaryActionButtons: UIStackView!
    @IBOutlet weak var cancelMemeButton: UIButton!
    @IBOutlet weak var downloadMemeButton: UIButton!
    @IBOutlet weak var changeFontButton: UIButton!
    
    @IBOutlet weak var primaryActionButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var primaryActionButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var primaryActionButtonXCoord: NSLayoutConstraint!
    @IBOutlet weak var memeTopCaptionTextField: UITextField!
    @IBOutlet weak var primaryActionButtonDistanceFromBottom: NSLayoutConstraint!
    @IBOutlet weak var memeBottomCaptionConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolbarDistanceFromBottom: NSLayoutConstraint!
    @IBOutlet weak var secondaryButtonsDistanceFromBottom: NSLayoutConstraint!
    @IBOutlet weak var topCaptionDistanceFromTop: NSLayoutConstraint!
    @IBOutlet weak var bottomCaptionDistanceFromCameraButton: NSLayoutConstraint!
    
    var captureSession: AVCaptureSession?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    var meme: Meme!
    var memeImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        meme = Meme.init(originalImage: UIImage(named: "Close")!, memeImage: UIImage(named: "Close")!, topCaption: "", bottomCaption: "")
        
        primaryActionButton.isEnabled = true
        setupCamera()
        setupCaptions()
        setupButtons()
    }
    
    // MARK: Configure Camera and Views for Capturing and Showing Live Camera Feed
    func setupCamera()
    {
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        {
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
        topCaptionDistanceFromTop.constant = 10.0
    }
    
    // MARK: Present Share Options Modally
    func shareMeme(meme: UIImage)
    {
        let shareController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    
    func configureMemeCreationUI(appState: AppState)
    {
        switch appState
        {
            case .captionEditing:
                // End live camera capture session
                captureSession?.stopRunning()
                
                // Remove preview layer from view
                cameraPreviewLayer?.removeFromSuperlayer()
                
                // Animate primary button and toolbar
                animatePrimaryActionButton()
                
                // Display captured image in UI
                addImageToView(image: meme.originalImage)
                
                primaryActionButton.isEnabled = false
                primaryActionButton.setImage(#imageLiteral(resourceName: "Camera-Released-No-Shadow"), for: [.normal, .disabled])
                primaryActionButton.setImage(#imageLiteral(resourceName: "Send"), for: [.selected, .disabled])
                cancelMemeButton.isHidden = false
                downloadMemeButton.isEnabled = false
                topCaptionDistanceFromTop.constant = 55.0
                bottomCaptionDistanceFromCameraButton.constant = 15.0
            
                enableCaptions(true)
                memeTopCaptionTextField.placeholder = "TOP"
                memeBottomCaptionTextField.placeholder = "BOTTOM"
            
            case .imageSelection:
                setupCamera()
                setupCaptions()
                setupButtons()
                resetPrimaryActionButton()
                memeImageView.removeFromSuperview()
            
                enableCaptions(false)
        }
    }
    
    func animatePrimaryActionButton()
    {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
            self.primaryActionButtonXCoord.constant += 130
            self.primaryActionButtonDistanceFromBottom.constant += 65
            self.primaryActionButtonHeight.constant -= 130
            self.primaryActionButtonWidth.constant -= 130
            self.toolbarDistanceFromBottom.constant += 44
            self.secondaryButtonsDistanceFromBottom.constant += 40
            
            self.view.layoutIfNeeded()
        }) { (true) in
            // Show secondary action buttons
            self.primaryActionButton.isHidden = false
            self.primaryActionButton.isSelected = true
            self.secondaryActionButtons.isHidden = false
        }
    }
    
    func resetPrimaryActionButton()
    {
        UIView.animate(withDuration: 0.4) {
            self.primaryActionButtonXCoord.constant -= 130
            self.primaryActionButtonDistanceFromBottom.constant -= 65
            self.primaryActionButtonHeight.constant += 130
            self.primaryActionButtonWidth.constant += 130
            self.toolbarDistanceFromBottom.constant -= 44
            self.secondaryButtonsDistanceFromBottom.constant -= 40
            
            self.view.layoutIfNeeded()
        }
    }
    
    func changeConstraints(constraint: CGFloat, value: CGFloat, sign: (CGFloat, CGFloat) -> CGFloat) -> CGFloat
    {
        return sign(constraint, value)
    }
    
    func addImageToView(image: UIImage)
    {
        memeImageView = UIImageView(image: image)
        memeImageView.contentMode = .scaleAspectFit
        memeImageView.frame = cameraPreviewView.frame
        
        cameraPreviewView.addSubview(memeImageView)
        cameraPreviewView.autoresizesSubviews = true
    }
    
    func enableCaptions(_ state: Bool)
    {
        memeTopCaptionTextField.isEnabled = state
        memeBottomCaptionTextField.isEnabled = state
        
        memeTopCaptionTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.15)
        memeTopCaptionTextField.alpha = 1.0
    }
    
    @IBAction func takePicture(_ sender: UIButton)
    {
        guard let capturePhotoOutput = capturePhotoOutput else
        {
            return
        }
        
        // MARK: Configure Photo Settings
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg, AVVideoCompressionPropertiesKey: [AVVideoQualityKey: 1.0]])
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        // MARK: Capture Photo with Preconfigured Settings
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
        
        // Change appState to .captionEditing when image has finished processing (see delegate function)
    }
    
    @IBAction func launchGallery(_ sender: Any)
    {
        let imageSourceType: UIImagePickerControllerSourceType = .photoLibrary
        handleImageSelection(imageSourceType: imageSourceType)
        
        // Change appState to .captionEditing when image has been selected (see delegate function)
    }
    
    @IBAction func editMemeCaption(_ sender: Any)
    {
        memeTopCaptionTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        
        if memeTopCaptionTextField.hasText == true && memeBottomCaptionTextField.hasText == true
        {
            downloadMemeButton.isEnabled = true
        }
    }
    
    @IBAction func downloadMeme(_ sender: UIButton)
    {
        // Allow download of meme if both Caption fields contain text
        UIImageWriteToSavedPhotosAlbum(meme.memeImage, nil, nil, nil)
    }
    
    @IBAction func cancelMeme(_ sender: UIButton)
    {
        configureMemeCreationUI(appState: .imageSelection)
        memeTopCaptionTextField.text = ""
        memeBottomCaptionTextField.text = ""
    }
}

