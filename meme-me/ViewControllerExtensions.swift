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
            imagePickerView.contentMode = memeImageContentMode
            imagePickerView.image = pickedImage
            switchEditModeControls(activate: true)

            imagePickerSuccess = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(
        _ picker: UIImagePickerController) {
        
        imagePickerSuccess = false
        switchEditModeControls(activate: false)
        
        dismiss(animated: true, completion: nil)
    }
    
    func loadImagePickerSource() {
        
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
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
        
        prepareMemeControls(activate: true)
        
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        prepareMemeControls(activate: false)
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
            if view.frame.origin.y == 0 && inputFieldBottom.isFirstResponder {
                self.view.frame.origin.y =  keyboardSize * -1
            }
        }
    }
    
    //
    // MARK: Image Handler Methods
    //
    
    func saveImageModel(memedImage: UIImage) {
        
        // init/define our memed image model struct
        let meme = Meme(
            textTop: inputFieldTop.text!,
            textBottom: inputFieldBottom.text!,
            imageOrigin: imagePickerView.image!,
            image: memedImage
        )
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    func saveImage(renderedImage: UIImage) {
        
        // write incoming image to photo album
        UIImageWriteToSavedPhotosAlbum(renderedImage, self, #selector(handleImageStorage(_:didFinishSavingWithError:contextInfo:)), nil)
        
        saveImageModel(memedImage: renderedImage)
    }
    
    func shareImage(renderedImage: UIImage) {
        
        // open activitiy controller to share the incoming image
        let activityViewController = UIActivityViewController(activityItems: [renderedImage as UIImage], applicationActivities: nil)
        // let save the meme as model only if share was completed successfully
        activityViewController.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.saveImageModel(memedImage: renderedImage)
            }
        }
        
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
            displayAlert(alertTitle: "Meme not saved!", alertMessage: ioError.localizedDescription, alertButtonText: "OK")
        } else {
            displayAlert(alertTitle: "Meme saved!", alertMessage: "Your memed image has been saved to your photos", alertButtonText: "OK")
        }
    }
    
    func displayAlert(alertTitle: String, alertMessage: String, alertButtonText: String) {
    
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alertButtonText, style: .default))
        present(alertController, animated: true)
    }
    
    //
    // MARK: UI/Control Methods
    //
    
    func prepareControls() {
        
        imagePickerSuccess = false
        imagePickerController.delegate = self
        exportButton.isEnabled = false
        
        prepareEditModeControls(textFields: [
            inputFieldTop: memeTextFieldTopDefault,
            inputFieldBottom: memeTextFieldBottomDefault
            ], activate: false
        )
        
        prepareMemeControls(activate: true)
    }
    
    //
    // check for predefined fontrange availability, switch to alternate one if given one not exist
    //
    func getAvailableMemeFontName(fontNamesAvailable: [String]) -> String {
        
        for fontName in fontNamesAvailable {
            if isFontNameAvailable(fontName: fontName) {
                return fontName
            }
        }
        
        return memeFontNameFailback
    }
    
    //
    // prepare our meme input controls using dictionary of inputfields
    //
    func prepareEditModeControls(textFields: [UIMemeTextField: String], activate: Bool) {
    
        usedMemeFontName = getAvailableMemeFontName(fontNamesAvailable: memeFontNames)
        
        for (textField, defaultText) in textFields {
            
            let memeTextAttributes = [
                NSStrokeColorAttributeName : UIColor.black,
                NSForegroundColorAttributeName : UIColor.white,
                NSFontAttributeName : UIFont(name: usedMemeFontName, size: memeFontSize)!,
                NSStrokeWidthAttributeName : -3
                ] as [String : Any]
            
            textField.defaultTextAttributes = memeTextAttributes
            textField.adjustsFontSizeToFitWidth = true
            textField.minimumFontSize = memeFontSizeMinimum
            textField.delegate = memeTextFieldDelegate
            textField.textAlignment = .center
            textField.text = defaultText
            textField.contentDefault = defaultText
            
            textField.isHidden = !activate
        }
    }

    func prepareMemeControls(activate: Bool) {
    
        cameraButton.isEnabled = activate && isCameraAvailable()
        photoLibButton.isEnabled = activate && isLocalImageStockAvailable()
        exportButton.isEnabled = activate && isImageExportable()
    }
    
    func prepareToolBarControls(activate: Bool) {
        
        toolBarTop.isHidden = !activate
        toolBarBottom.isHidden = !activate
    }
    
    func switchEditModeControls(activate: Bool) {
        
        prepareEditModeControls(textFields: [
            inputFieldTop: memeTextFieldTopDefault,
            inputFieldBottom: memeTextFieldBottomDefault
            ], activate: activate
        )
    }
    
    //
    // MARK: Internal Helper Methods
    //
    
    func isFontNameAvailable(fontName: String) -> Bool {
    
        for name in UIFont.familyNames {
            
            for fontFamilyName in UIFont.fontNames(forFamilyName: name) {
                if fontFamilyName == fontName {
                    return true
                }
            }
        }
        
        return false
    }
    
    func isImageExportable() -> Bool {
        return imagePickerSuccess
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
