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
        
        imagePickerView.contentMode = .scaleAspectFit
        imagePickerView.image = UIImage(imageLiteralResourceName: "WelcomePortrait")
        
        if (toInterfaceOrientation.isLandscape) {
            imagePickerView.image = UIImage(imageLiteralResourceName: "WelcomeLandscape")
        }
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFill
            imagePickerView.image = pickedImage
            prepareEditModeControls(activate: true)
            imagePickerSuccess = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(
        _ picker: UIImagePickerController) {
        
        imagePickerSuccess = false
        prepareEditModeControls(activate: false)
        
        dismiss(animated: true, completion: nil)
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
        
        preparePhotoControls(activate: false)
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize
            }
        }
        
        
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        preparePhotoControls(activate: true)
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize
            }
        }
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
        
        inputFieldTop.adjustsFontSizeToFitWidth = true
        inputFieldBottom.adjustsFontSizeToFitWidth = true
        
        inputFieldTop.minimumFontSize = 0.5
        inputFieldBottom.minimumFontSize = 0.5
    }
    
    func preparePhotoControls(activate: Bool) {
    
        cameraButton.isEnabled = !activate
        photoLibButton.isEnabled = !activate
    }
    
    func loadImagePickerSource() {
        
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
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
