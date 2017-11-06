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
    @IBOutlet weak var topCaptionDistanceFromCancelButton: NSLayoutConstraint!
    @IBOutlet weak var bottomCaptionDistanceFromCameraButton: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonDistanceFromTop: NSLayoutConstraint!
    
    var appState: AppState!
    
    var captureSession: AVCaptureSession?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    var meme: Meme!
    var memeImageView: UIImageView!
    
    var memeCaptions: [UITextField] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        meme = Meme.init(originalImage: nil, memeImage: nil, topCaption: nil, bottomCaption: nil)
        memeCaptions = [memeTopCaptionTextField, memeBottomCaptionTextField]
        
        hideKeyboardWhenTappedOutside()
        
        appState = AppState.imageSelection
        setupCamera()
        setupCaptions()
        setupButtons()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        unsubcribeFromKeyboardNotifcations()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func keyboardWillShow(_ notification: Notification)
    {
        resetView()
        
        if (memeBottomCaptionTextField.isFirstResponder)
        {
            super.keyboardWillShow(notification)
        }
    }
    
    @IBAction func takePicture(_ sender: UIButton)
    {
        if appState == AppState.imageSelection
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
        else
        {
            // MARK: Generate meme image (original image + captions - onscreen controls)
            generateCompletedMeme()
            
            if let meme = meme.memeImage
            {
                shareMeme(meme: meme)
            }
        }
    }
    
    func generateCompletedMeme()
    {
        meme.topCaption = memeTopCaptionTextField.text!
        meme.bottomCaption = memeBottomCaptionTextField.text!
        
        // Hide onscreen controls
        hideOnscreenControls(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Unhide onscreen controls
        hideOnscreenControls(false)
        
        meme.memeImage = memedImage
    }
    
    func hideOnscreenControls(_ state: Bool)
    {
        primaryActionButton.isHidden = state
        secondaryActionButtons.isHidden = state
        cancelMemeButton.isHidden = state
    }
    
    @IBAction func launchGallery(_ sender: Any)
    {
        let imageSourceType: UIImagePickerControllerSourceType = .photoLibrary
        handleImageSelection(imageSourceType: imageSourceType)
        
        // Change appState to .captionEditing when image has been selected (see delegate function)
    }
    
    @IBAction func downloadMeme(_ sender: UIButton)
    {
        // Allow download of meme if both Caption fields contain text
        generateCompletedMeme()
        
        if let meme = meme.memeImage
        {
            UIImageWriteToSavedPhotosAlbum(meme, nil, nil, nil)
        }
    }
    
    @IBAction func cancelMeme(_ sender: UIButton)
    {
        appState = AppState.imageSelection
        configureMemeCreationUI()
    }
}

