//
//  CameraViewController+UIImagePickerControllerDelegate.swift
//  MemeMe
//
//  Created by Jase-Omeileo West on 10/25/17.
//  Copyright © 2017 Omeileo. All rights reserved.
//

import Foundation
import UIKit

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func handleImageSelection(imageSourceType: UIImagePickerControllerSourceType)
    {
        let galleryImagePicker = UIImagePickerController()
        galleryImagePicker.delegate = self
        galleryImagePicker.sourceType = imageSourceType
        present(galleryImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        memeImage = UIImage(data: imageData!)!
        
        addImageToView(image: image)
    }
}
