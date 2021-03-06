//
//  CameraViewController+ModifyInterface.swift
//  MemeMe
//
//  Created by Jase-Omeileo West on 11/5/17.
//  Copyright © 2017 Omeileo. All rights reserved.
//

import Foundation
import UIKit

extension CameraViewController
{
    @objc func textFieldDidChange (_ textField: UITextField)
    {
        if textField.hasText
        {
            adjustTextFieldVisibility(textField: textField, colorAlpha: 0.0)
        }
        else
        {
            adjustTextFieldVisibility(textField: textField, colorAlpha: 0.15)
        }
        
        if memeTopCaptionTextField.hasText == true && memeBottomCaptionTextField.hasText == true
        {
            enableActionButtons(true)
        }
        else
        {
            enableActionButtons(false)
        }
    }
    
    // MARK: Present Share Options Modally
    func shareMeme(meme: UIImage)
    {
        let shareController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        present(shareController, animated: true) {
            UIImageWriteToSavedPhotosAlbum(meme, nil, nil, nil)
        }
    }
    
    func configureMemeCreationUI()
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
                if let image = meme.originalImage
                {
                    addImageToView(image: image)
                }
                
                // Configure primaryActionButton for different states
                primaryActionButton.setImage(#imageLiteral(resourceName: "Camera-Released-No-Shadow"), for: [.normal, .disabled])
                primaryActionButton.setImage(#imageLiteral(resourceName: "Send-Disabled"), for: [.selected, .disabled])
                primaryActionButton.setImage(#imageLiteral(resourceName: "Send"), for: [.highlighted, .selected])

                cancelMemeButton.isHidden = false
                enableActionButtons(false)
                enableCaptions(true)
            
            case .imageSelection:
                setupCamera()
                setupCaptions()
                setupButtons()
                resetPrimaryActionButton()
                memeImageView.removeFromSuperview()
                
                enableCaptions(false)
            
            default: print("")
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
            self.cancelButtonDistanceFromTop.constant = 10.0
            self.topCaptionDistanceFromCancelButton.constant = 15.0
            self.bottomCaptionDistanceFromCameraButton.constant = 15.0
            
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
        let memeView = UIView()
        memeView.translatesAutoresizingMaskIntoConstraints = false
        
        memeImageView = UIImageView(image: image)
        memeImageView.contentMode = .scaleAspectFit
        memeImageView.frame = cameraPreviewView.bounds

        memeView.addSubview(memeImageView)
        cameraPreviewView.addSubview(memeView)
        
        configureCameraPreviewViewConstraints()
    }
    
    func configureCameraPreviewViewConstraints()
    {
        let centerXLayoutConstraint = NSLayoutConstraint(item: memeImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: cameraPreviewView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let centerYLayoutConstraint = NSLayoutConstraint(item: memeImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: cameraPreviewView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        
        cameraPreviewView.addConstraint(centerXLayoutConstraint)
        cameraPreviewView.addConstraint(centerYLayoutConstraint)
    }
    
    func enableCaptions(_ state: Bool)
    {
        for caption in memeCaptions
        {
            caption.isEnabled = state
            adjustTextFieldVisibility(textField: caption, colorAlpha: 0.15)
        }
        
        if state == true
        {
            populateTextField(textField: memeCaptions[0], text: "TOP")
            populateTextField(textField: memeCaptions[1], text: "BOTTOM")
        }
        else
        {
            for caption in memeCaptions
            {
                populateTextField(textField: caption, text: nil)
            }
        }
    }
    
    func populateTextField(textField: UITextField, text: String?)
    {
        textField.placeholder = text
        textField.text = nil
    }
    
    func adjustTextFieldVisibility(textField: UITextField, colorAlpha: CGFloat)
    {
        textField.backgroundColor = UIColor(white: 1.0, alpha: colorAlpha)
        textField.alpha = 1.0
    }
    
    func enableActionButtons(_ state: Bool)
    {
        downloadMemeButton.isEnabled = state
        primaryActionButton.isEnabled = state
    }
}
