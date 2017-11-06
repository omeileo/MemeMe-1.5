//
//  CameraViewController+UITextFieldDelegate.swift
//  MemeMe
//
//  Created by Jase-Omeileo West on 11/6/17.
//  Copyright © 2017 Omeileo. All rights reserved.
//

import UIKit

extension CameraViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField
        {
            nextField.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
        }
        
        return false
    }
}
