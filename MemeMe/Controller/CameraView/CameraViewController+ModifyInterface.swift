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
            //self.topCaptionDistanceFromCancelButton.constant = 55.0
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
        
        memeBottomCaptionTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.15)
        memeBottomCaptionTextField.alpha = 1.0
        
    }
}
