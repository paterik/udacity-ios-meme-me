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
            name: NSNotification.Name.UIKeyboardDidHide,
            object: nil
        )
    }
    
    func unSubscribeToKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.UIKeyboardWillShow, object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.UIKeyboardDidHide, object: nil
        )
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        
        self.view.frame.origin.y += getKeyboardHeight(notification: notification)
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    func prepareControls() {
        
        imagePickerSuccess = false
        imagePickerController.delegate = self
        cameraButton.isEnabled = isCameraAvailable()
        photoLibButton.isEnabled = isLocalImageStockAvailable()
        prepareEditModeControls(activate: false)
    }
    
    func prepareEditModeControls(activate: Bool) {
        
        inputFieldTop.isHidden = !activate
        inputFieldBottom.isHidden = !activate
        
        inputFieldTop.font = UIFont(name: "Impact", size: 28)
        inputFieldBottom.font = UIFont(name: "Impact", size: 28)
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
