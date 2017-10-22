//
//  CameraViewController+CapturePhoto.swift
//  MemeMe
//
//  Created by Jase-Omeileo West on 10/21/17.
//  Copyright © 2017 Omeileo. All rights reserved.
//  Code referenced from https://github.com/rizwankce/Camera/blob/master/Camera/ViewController.swift

import AVFoundation
import UIKit

extension CameraViewController: AVCapturePhotoCaptureDelegate
{
//    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?)
//    {
//        // Ensure that a photo sample buffer is retrieved
//        guard error == nil, let photoSampleBuffer = photoSampleBuffer else
//        {
//            print("Error capturing photo: \(String(describing: error))")
//            return
//        }
//
//        // Convert photo sample buffer into a JPEG image data stream
//        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else
//        {
//            return
//        }
//    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?)
    {
        guard let JPEGimageData = photo.fileDataRepresentation() else
        {
            return
        }
        
        if let capturedImage = UIImage(data: JPEGimageData, scale: 1.0)
        {
            // display 
        }
    }
}
