//
//  UITextFieldDelegate.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 13.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let memeTextField = textField as! UIMemeTextField
        if (!memeTextField.differsFromDefault()) {
            memeTextField.text = ""
        }
    }
}
