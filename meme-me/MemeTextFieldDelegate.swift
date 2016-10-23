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
    
    func textFieldShouldReturn(
        _ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()

        return true
    }
    
    func textField(
        _ textField: UITextField,
          shouldChangeCharactersIn range: NSRange,
          replacementString string: String) -> Bool {
        
        if let text = textField.text {
            textField.text = (text as NSString).replacingCharacters(in: range, with: string.uppercased())
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(
        _ textField: UITextField) {
        
        let memeTextField = textField as! UIMemeTextField
        if (!memeTextField.hasDefaultText()) {
            memeTextField.text = ""
        }
    }
}
