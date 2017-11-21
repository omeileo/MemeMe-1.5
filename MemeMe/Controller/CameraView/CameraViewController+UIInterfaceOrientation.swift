//
//  CameraViewController+UIInterfaceOrientation.swift
//  MemeMe
//
//  Created by Jase-Omeileo West on 11/20/17.
//  Copyright © 2017 Omeileo. All rights reserved.
//

import Foundation
import UIKit
import AVKit

extension UIInterfaceOrientation
{
    var videoOrientation: AVCaptureVideoOrientation?
    {
        switch self {
            case .portraitUpsideDown: return .portraitUpsideDown
            case .landscapeRight: return .landscapeRight
            case .landscapeLeft: return .landscapeLeft
            case .portrait: return .portrait
            default: return nil
        }
    }
}
