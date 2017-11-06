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
    
    var captureSession: AVCaptureSession?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    var meme: Meme!
    var memeImageView: UIImageView!
    
    let memeCaptionAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -6.00]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        meme = Meme.init(originalImage: UIImage(named: "Close")!, memeImage: UIImage(named: "Close")!, topCaption: "", bottomCaption: "")
        
        hideKeyboardWhenTappedOutside()
        subscribeToKeyboardNotifications()
        
        setupCamera()
        setupCaptions()
        setupButtons()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        unsubcribeFromKeyboardNotifcations()
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
        
    }
    
    @IBAction func downloadMeme(_ sender: UIButton)
    {
        // Allow download of meme if both Caption fields contain text
        UIImageWriteToSavedPhotosAlbum(meme.memeImage, nil, nil, nil)
    }
    
    @IBAction func cancelMeme(_ sender: UIButton)
    {
        configureMemeCreationUI(appState: .imageSelection)
    }
}

