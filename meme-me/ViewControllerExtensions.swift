//
//  ViewControllerExtensions.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 13.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        if (imagePickerSuccess) {
            return
        }
        
        if (toInterfaceOrientation.isLandscape) {
            imagePickerView.image = UIImage(imageLiteralResourceName: "WelcomeLandscape")
            imagePickerView.contentMode = .scaleAspectFit
        } else {
            imagePickerView.image = UIImage(imageLiteralResourceName: "WelcomePortrait")
            imagePickerView.contentMode = .scaleAspectFit
        }
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.keyboardWillAppear),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.keyboardWillDisappear),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    func unSubscribeToKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.UIKeyboardWillShow, object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.UIKeyboardWillHide, object: nil
        )
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize
            }
        }
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize
            }
        }
        
    }
    
    func _getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    func prepareControls() {
        
        imagePickerSuccess = false
        prepareEditModeControls(activate: false)
        
        cameraButton.isEnabled = isCameraAvailable()
        photoLibButton.isEnabled = isLocalImageStockAvailable()
        
        imagePickerController.delegate = self
        inputFieldTop.delegate = memeTextFieldDelegate
        inputFieldBottom.delegate = memeTextFieldDelegate
        
        inputFieldTop.text = memeTextFieldTopDefault
        inputFieldTop.contentDefault = memeTextFieldTopDefault
        inputFieldBottom.text = memeTextFieldBottomDefault
        inputFieldBottom.contentDefault = memeTextFieldBottomDefault
    }
    
    func prepareEditModeControls(activate: Bool) {
        
        inputFieldTop.isHidden = !activate
        inputFieldBottom.isHidden = !activate
        
        inputFieldTop.font = UIFont(name: memeFontName, size: memeFontSize)
        inputFieldBottom.font = UIFont(name: memeFontName, size: memeFontSize)
    }
    
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    func isPhotoLibrarayAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    func isSavedPhotosAlbumAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)
    }
    
    func isLocalImageStockAvailable() -> Bool {
        return isPhotoLibrarayAvailable() || isSavedPhotosAlbumAvailable()
    }
}
