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
    
    //
    // MARK: ImagePicker Delegate Methods
    //
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFill
            imagePickerView.image = pickedImage
            prepareEditModeControls(activate: true)
            exportButton.isEnabled = true
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
    
    func loadImagePickerSource() {
        
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    //
    // MARK: Observer Methods
    //
    
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
    
    //
    // MARK: Image Handler Methods
    //
    
    func saveImageModel(memedImage: UIImage) {
        
        // init/define our memed image model struct
        let _ = Meme(
            textTop: inputFieldTop.text!,
            textBottom: inputFieldBottom.text!,
            imageOrigin: imagePickerView.image!,
            image: memedImage
        )
    }
    
    func saveImage(renderedImage: UIImage) {
        
        saveImageModel(memedImage: renderedImage)
        
        // write incoming image to photo album
        UIImageWriteToSavedPhotosAlbum(renderedImage, self, #selector(handleImageStorage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func shareImage(renderedImage: UIImage) {
        
        saveImageModel(memedImage: renderedImage)
        
        // open activitiy controller to share the incoming image
        let activityViewController = UIActivityViewController(activityItems: [renderedImage as UIImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    func renderMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        prepareToolBarControls(activate: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        prepareToolBarControls(activate: true)
        
        return memedImage
    }
    
    func handleImageStorage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let ioError = error {
            
            let alertController = UIAlertController(title: "Meme not saved!", message: ioError.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
            
        } else {
            
            let alertController = UIAlertController(title: "Meme Saved!", message: "Your memed image has been saved to your local photos", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
            
        }
    }
    
    //
    // MARK: UI/Control Methods
    //
    
    func prepareControls() {
        
        imagePickerSuccess = false
        
        prepareEditModeControls(activate: false)
        
        cameraButton.isEnabled = isCameraAvailable()
        photoLibButton.isEnabled = isLocalImageStockAvailable()
        exportButton.isEnabled = false
        
        inputFieldTop.delegate = memeTextFieldDelegate
        inputFieldBottom.delegate = memeTextFieldDelegate
        imagePickerController.delegate = self
        
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
    
        cameraButton.isEnabled = !activate && isCameraAvailable()
        photoLibButton.isEnabled = !activate && isLocalImageStockAvailable()
        exportButton.isEnabled = !activate
    }
    
    func prepareToolBarControls(activate: Bool) {
        
        toolBarTop.isHidden = !activate
        toolBarBottom.isHidden = !activate
    }
    
    //
    // MARK: Internal Helper Methods
    //
    
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
